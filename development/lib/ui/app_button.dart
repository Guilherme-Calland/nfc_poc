import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final String label;
  const AppButton({super.key, required this.onTap, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        height: 64,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18),

          ),
        ),
      ),
    );
  }
}