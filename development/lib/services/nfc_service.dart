import 'package:flutter/material.dart';
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
          message = String.fromCharCodes(payload).substring(3);
        }
      }catch(e){
        message = 'erro lendo nfc: $e';
      }
      onResult(message);
      nfcManager.stopSession();
    });
  }

  void writeNFC(String code, Function() onFinish) {
    final nfcManager = _instance ?? NfcManager.instance;
    nfcManager.startSession(onDiscovered: (NfcTag tag) async {
      try {
        final ndef = Ndef.from(tag);
        if (ndef == null) {
          debugPrint("Tag is not NDEF compliant.");
          return;
        }

        if (!ndef.isWritable) {
          debugPrint("Tag is not writable.");
          return;
        }

        // Create an NDEF message
        final message = NdefMessage([
          NdefRecord.createText(code),
        ]);

        await ndef.write(message);

        debugPrint("Success in writing: ${String.fromCharCodes(message.records.first.payload)}");
      } catch (e) {
        debugPrint("Write failed: $e");
      } finally {
        onFinish();
        NfcManager.instance.stopSession();
      }
    });
  }


  Future<bool> deviceHasNFC() async {
    final nfcManager = _instance ?? NfcManager.instance;
    return await nfcManager.isAvailable();
  }

}