import 'package:flutter/material.dart';
import 'package:nfc_poc/ui/home_page.dart';

main(){
  runApp(NfcPoc());
}

class NfcPoc extends StatelessWidget {
  const NfcPoc({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

