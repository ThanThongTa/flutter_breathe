import 'package:breathe/datamodels/settings.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// Widget für den inneren Kreis auf der Startseite
class InnerCircle extends StatelessWidget {
  const InnerCircle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Settings.defaultThemeColor,
        shape: BoxShape.circle,
      ),
      child: const Text(
        'Welcome to Breathe',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
