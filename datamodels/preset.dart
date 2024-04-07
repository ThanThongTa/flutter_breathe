import 'package:breathe/datamodels/circle_phase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'preset.g.dart';

// Presets beschreiben die Konfiguration einer Kreis Animation
@HiveType(typeId: 1)
class Preset {
  @HiveField(0)
  Widget? child; // eventuelles Widget innerhalb der Animation
  @HiveField(1)
  late bool showTexts; // sollen Texte angezeigt werden?
  @HiveField(2)
  late bool showCount; // soll der Count angezeigt werden?
  @HiveField(3)
  late bool skipHolds; // sollen HoldIn/HoldOut übersprungen werden?
  @HiveField(4)
  late bool isFavorite; // wurde die Animation als Favorit gespeichert?
  @HiveField(5)
  late bool isStart; // ist es die Start-Animation?
  @HiveField(6)
  late String
      name; // Name wird nur gebraucht, wenn die Animation gespeichert wird
  @HiveField(7)
  late Map<CirclePhase, double>?
      durationsInSeconds; // Dauer jeder einzelnen Phase in Sekunden
  @HiveField(8)
  late Map<CirclePhase, String>? texts; // Text für jede einzelne Phase
  @HiveField(9)
  late int
      breathsBeforeRetention; // Count der Breaths, die vor einer RetentionPhase gemacht werden
  @HiveField(10)
  late bool hasRetention; // wird auch eine Retention Phase animiert?
  @HiveField(11)
  late int
      selectedBreathSpeedBeforeRetention; // Gesamtdauer einer Ein- und Ausatmung vor der Retention
  @HiveField(12)
  String? key;

  // Konstruktor
  Preset({
    required this.name,
    this.showTexts = false,
    this.showCount = false,
    this.skipHolds = false,
    this.isFavorite = false,
    this.isStart = false,
    this.durationsInSeconds,
    this.texts,
    this.breathsBeforeRetention = 0,
    this.hasRetention = false,
    this.selectedBreathSpeedBeforeRetention = 0,
    required this.key,
    this.child,
  });
}
