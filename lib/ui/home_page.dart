import 'package:flutter/material.dart';
import 'package:nfc_poc/core/colors.dart';
import 'package:nfc_poc/repositories/repository.dart';
import 'package:nfc_poc/services/nfc_service.dart';
import 'package:nfc_poc/ui/app_button.dart';

const appTheme = Colors.green;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _message = '';
  bool _readingTag = false;

  late final Repository repository;

  @override
  void initState() {
    super.initState();
    final service = NfcService();
    repository = Repository(service);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _readingTag ? 
      Center(
          child: Text(
            'Pronto pra ler...',
            style: TextStyle(color: appTheme, fontSize: 32),
          ),
        )
      :
      
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
                    _message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28
                    ),
                  ),
                ),
              ),
              if(!_readingTag)
              AppButton(
                onTap: _readNFC,
                label: "Ler tag NFC",
                color: Colors.blueAccent,
              ),
              AppButton(
                onTap: _writeToNFC,
                label: "Escrever na tag NFC",
                color: AppColors.writeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _readNFC() async{
    bool deviceHasNFC = await repository.deviceCanReadWrite();
    if(deviceHasNFC){
      repository.readData((result){
        setState(() {
          _readingTag = true;
        });
        _message = result;
        _readingTag = false;
      });
    }else{
      _message = 'Esse dispositivo não está habilitado para o uso de nfc';
    }
    setState(() {});
  }

  void _writeToNFC() {
    // setState(() {
    //   _statusMessage = "Waiting for an NFC tag...";
    // });

    // NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    //   try {
    //     final ndef = Ndef.from(tag);
    //     if (ndef == null) {
    //       setState(() {
    //         _statusMessage = "Tag is not NDEF compliant.";
    //       });
    //       return;
    //     }

    //     if (!ndef.isWritable) {
    //       setState(() {
    //         _statusMessage = "Tag is not writable.";
    //       });
    //       return;
    //     }

    //     // Create an NDEF message
    //     final message = NdefMessage([
    //       NdefRecord.createText(data),
    //     ]);

    //     // Write the NDEF message to the tag
    //     await ndef.write(message);

    //     setState(() {
    //       _statusMessage = "Write successful! Data: $data";
    //     });
    //   } catch (e) {
    //     setState(() {
    //       _statusMessage = "Write failed: $e";
    //     });
    //   } finally {
    //     NfcManager.instance.stopSession();
    //   }
    // });
  }
}

