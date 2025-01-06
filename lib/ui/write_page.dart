import 'package:flutter/material.dart';
import 'package:nfc_poc/core/colors.dart';
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (val){
                text = val;
              }
            ),
            AppButton(onTap: () => _onTextConfirm(context, text), color: AppColors.writeColor, label: 'Confirmar')
          ],
        ),
      ),
    );
  }

  _onTextConfirm(BuildContext context, String? result) {
    Navigator.pop(context, result);
  }
}