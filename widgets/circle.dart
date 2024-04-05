import 'package:breathe/datamodels/settings.dart';
import 'package:flutter/material.dart';

// erstellt einen Standard Container als Kreis
// mit einem bestimmten Radius und optional einer Farbe
// optional kann auch ein Widget als Child mitgegeben werden
class Circle extends StatelessWidget {
  final Widget? child;
  final double radius;
  final Color color;

  const Circle({
    super.key,
    required this.radius,
    this.child, // optional, null wenn nichts angegeben ist
    this.color = Colors.teal, // optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Breite und Höhe des Kreises ist der Durchmesser
      // also doppelter Radius
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Settings.defaultThemeColor, width: 2),
      ),
      child: child,
    );
  }
}
