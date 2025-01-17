import 'package:nfc_poc/services/nfc_service.dart';

class Repository{
  final NfcService _service;
  Repository(this._service);

  void readData(Function(String) onResult)async{
    _service.readNFC(onResult);
  }

  void writeData(String code, Function() onFinish){
    _service.writeNFC(code, onFinish);
  }

  Future<bool> deviceCanReadWrite()async{
    return await _service.deviceHasNFC();
  }

}