import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  NfcManager? _instance;
  void readNFC(
    Function(String) onResult
  ) async{
    final nfcManager = _instance ?? NfcManager.instance;
    nfcManager.startSession(onDiscovered: (tag) async {
      late String message;
      try{
        final ndef = Ndef.from(tag);
        bool tagNotFormatted = (ndef == null) || (ndef.cachedMessage == null);
        if(tagNotFormatted){
          message = 'Não tem dados gravados nessa tag';
        } else {
          final payload = ndef.cachedMessage!.records.first.payload;
          message = String.fromCharCodes(payload);
        }
      }catch(e){
        message = 'erro lendo nfc: $e';
      }
      onResult(message);
      nfcManager.stopSession();
    });
  }

  Future<bool> deviceHasNFC() async {
    final nfcManager = _instance ?? NfcManager.instance;
    return await nfcManager.isAvailable();
  }
}