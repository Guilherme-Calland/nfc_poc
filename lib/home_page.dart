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
  bool _readingTag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _readingTag ? 
      Center(
        child: Text('Pronto pra ler...', style: TextStyle(color: appTheme, fontSize: 32),),
      ) :
      
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
                  vertical: 32.0,
                  horizontal: 16.0,
                ),
          child: Column(
            spacing: 16.0,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _nfcTag,
                    style: TextStyle(
                      color: appTheme,
                      fontSize: 22
                    ),
                  ),
                ),
              ),
              if(!_readingTag)
              GestureDetector(
                onTap: _scanNFC,
                child: Container(
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
        ),
      ),
    );
  }

  void _scanNFC() async{
    final nfcManager = NfcManager.instance;
    bool deviceHasNFCScan = await nfcManager.isAvailable();

    if(!deviceHasNFCScan){
      setState(() {
        _nfcTag = 'Leitura de NFC não está disponível nesse dispositivo';
      });
      return;
    }

    setState(() {
      _readingTag = true;
    });

    // initialize scan listener
    nfcManager.startSession(onDiscovered: (tag) async {
      try{
        final ndef = Ndef.from(tag);
        bool tagNotFormatted = (ndef == null) || (ndef.cachedMessage == null);
        final data = tag.data;
        if(tagNotFormatted){
          setState(() {
            _nfcTag = 'nfc não está formatado\ndata:$data\nentries:${data.entries}\nvalues:${data.values}';
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

        setState(() {
          _readingTag = false;
        });
      }
    });

    
  }
}

