import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

const appTheme = Colors.green;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _nfcTag = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 32,
        children: [
          if(_nfcTag != '')
          Text(_nfcTag),
          GestureDetector(
            onTap: _scanNFC,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              decoration: BoxDecoration(
                border: Border.all(color: appTheme),
              ),
              height: 58,
              child: Center(
                child: Text(
                  "Ler NFC",
                  style: TextStyle(color: appTheme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scanNFC() {
    final nfcManager = NfcManager.instance;

    // initialize scan listener
    nfcManager.startSession(onDiscovered: (tag) async {
      try{
        final ndef = Ndef.from(tag);
        bool tagNotFormatted = (ndef == null) || (ndef.cachedMessage == null);
        if(tagNotFormatted){
          setState(() {
            _nfcTag = 'nfc não está formatado';
          });
        } else {
          final payload = ndef.cachedMessage!.records.first.payload;
          setState(() {
            _nfcTag = String.fromCharCodes(payload);
          });
        }
      }catch(e){
        setState(() {
          _nfcTag = 'erro lendo nfc: $e';
        });
      } finally {
        nfcManager.stopSession();
      }
    });

    
  }
}

