import 'package:flutter/material.dart';
import 'package:nfc_poc/repositories/repository.dart';
import 'package:nfc_poc/services/nfc_service.dart';
import 'package:nfc_poc/ui/app_button.dart';
import 'package:nfc_poc/ui/write_page.dart';

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
  bool _writingTag = false;

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
            style: TextStyle(fontSize: 32),
          ),
        )
      : _writingTag ?
      Center(
          child: Text(
            'Pronto pra escrever...',
            style: TextStyle(fontSize: 32),
          ),
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
                    _message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28
                    ),
                  ),
                ),
              ),
              if(!_readingTag && !_writingTag)
              AppButton(
                onTap: _readNFC,
                label: "Ler tag NFC",
                color: Colors.blueAccent,
              ),
              if(!_readingTag && !_writingTag)
              AppButton(
                onTap: _writeToNFC,
                label: "Escrever na tag NFC",
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _readNFC() async{
    setState(() {
      _message = "";
      _readingTag = true;
    });

    bool deviceHasNFC = await repository.deviceCanReadWrite();
    if(deviceHasNFC){
      repository.readData((result){
        _message = result;
        setState(() {
          _readingTag = false;
        });
      });
    }else{
      setState(() {
        _readingTag = false;
        _message = "Esse dispositivo não está habilitado para leitura de tag nfc";
      });
    }
  }

  void _writeToNFC() async{
    setState(() {
      _writingTag = true;
      _message = "";
    });
    final bool deviceCanReadWrite = await repository.deviceCanReadWrite();
    if(deviceCanReadWrite){
      String code = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WritePage()),
      );

      debugPrint("written code: $code");

      repository.writeData(code, (){
        setState(() {
          _writingTag = false;
        });
      });
    }else{
      setState(() {
        _writingTag = false;
        _message = "Esse dispositivo não está habilitado para escrita de tag nfc";
      });
    }
  }
}

