import 'package:flutter/material.dart';
import 'package:nfc_poc/ui/app_button.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});
  @override
  Widget build(BuildContext context) {
    String? text;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (val){
                text = val;
              }
            ),
            AppButton(onTap: () => _onTextConfirm(context, text), color: Colors.blueAccent, label: 'Confirmar')
          ],
        ),
      ),
    );
  }

  _onTextConfirm(BuildContext context, String? result) {
    return Navigator.pop(context, result);
  }
}