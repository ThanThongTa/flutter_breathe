import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedCircleController {
  // der Animation Controller startet unter anderem die Animation
  // und kontrolliert die Gesamtdauer
  late AnimationController _animationController;
  // das aktive Preset für die Kreis Animation
  Preset? activePreset;
  // läuft die Animation gerade oder nicht?
  late bool isRunning;

  // Konstruktor, nimmt einen TickerProvider für den AnimationController als Parameter
  AnimatedCircleController();

  // Initiiert den AnimationController mit der berechneten Gesamtdauer der Animation
  void initState({required TickerProvider ticker, required Preset preset}) {
    activePreset = preset;
    _animationController = AnimationController(
      duration: Duration(seconds: getCurrentTotalDurationTime()),
      // vsync erwartet einen TickerProvider. Daher das
      // SingleTickerProviderStateMixin / aus dem TickerProvider
      vsync: ticker,
    );
  }

  // aktualisiert das aktive Preset
  void updatePreset({required TickerProvider ticker, required Preset preset}) {
    activePreset = preset;
    _animationController = AnimationController(
      duration: Duration(seconds: getCurrentTotalDurationTime()),
      // vsync erwartet einen TickerProvider. Daher das
      // SingleTickerProviderStateMixin / aus dem TickerProvider
      vsync: ticker,
    );
  }

// startet und wiederholt dann die Animation
  void repeat() {
    isRunning = true;
    _animationController.repeat();
  }

// dispose zum entfernen des Controllers aus dem Speicher
  void dispose() {
    _animationController.dispose();
  }

  // animiert den wachsenden und schrumpfenden Kreis
  Animation<double> animateCirclePhases() {
    // aus Übersichtlichkeit in zwei Zeilen
    List<TweenSequenceItem<double>> items = getCurrentAnimatedCirclePhases();
    return TweenSequence(items).animate(_animationController);
  }

  // Alle Animationen hier wiederholen sich, daher direkt repeat()
  void startAnimation() {
    isRunning = true;
    _animationController.repeat();
  }

  // stoppt die Animation
  void stopAnimation() {
    isRunning = false;
    _animationController.stop();
  }

  // berechnet die Summe der Weight Werte
  // und verwendet sie als Werte für die Duration der einzelnen Phasen in Sekunden
  int getTotalDurationTime(List<TweenSequenceItem<double>> items) {
    double durationInSeconds = 0;
    for (var item in items) {
      durationInSeconds += item.weight;
    }
    // Cast nach int ist notwendig, weil Weight als double angegeben wird
    // Duration allerdings in int angegeben werden muss
    return durationInSeconds.toInt();
  }

  // ermittelt die gesamte Dauer der Animation für die aktuelle Gesamtanimation
  int getCurrentTotalDurationTime() {
    double sum = 0;
    if (activePreset != null && activePreset?.durationsInSeconds != null) {
      for (var element in activePreset!.durationsInSeconds!.entries) {
        sum += element.value;
      }
    }
    return sum.toInt();
  }

  // ermittelt die Dauer der Animation für eine bestimmte Phase
  double getDurationInSecondsForPhase({required CirclePhase circlePhase}) {
    double sum = 1;
    if (activePreset != null && activePreset?.durationsInSeconds != null) {
      sum = activePreset!.durationsInSeconds?[circlePhase] ?? 1.0;
    }
    return sum;
  }

  // erstellt eine Liste aus TweenSequenceItems, die woanders zu einer Tween-Sequence
  // zusammengefügt werden sollen, damit die zusammen nacheinander angezeigt werden
  // können
  List<TweenSequenceItem<double>> getCurrentAnimatedCirclePhases() {
    return [
      // Growing
      animateCirclePhase(
        radius: Settings.defaultCircleRadius,
        circlePhase: CirclePhase.growing,
        durationInSeconds:
            getDurationInSecondsForPhase(circlePhase: CirclePhase.growing),
      ),
      // HoldIn
      animateCirclePhase(
        radius: Settings.defaultCircleRadius,
        circlePhase: CirclePhase.holdIn,
        durationInSeconds:
            getDurationInSecondsForPhase(circlePhase: CirclePhase.holdIn),
      ),
      // Shrinking
      animateCirclePhase(
        radius: Settings.defaultCircleRadius,
        circlePhase: CirclePhase.shrinking,
        durationInSeconds:
            getDurationInSecondsForPhase(circlePhase: CirclePhase.shrinking),
      ),
      // HoldOut
      animateCirclePhase(
        radius: Settings.defaultCircleRadius,
        circlePhase: CirclePhase.holdOut,
        durationInSeconds:
            getDurationInSecondsForPhase(circlePhase: CirclePhase.holdOut),
      ),
    ];
  }

// Erstellt die Animation für eine einzelne Phase
  TweenSequenceItem<double> animateCirclePhase(
      {required double radius,
      required CirclePhase circlePhase,
      required double durationInSeconds}) {
    // temporäre Variable für den Tween, für das nachher die TweenSequenceItem
    // erstellt werden soll
    Tween<double> tween;

    // was genau im tween steht, hängt von der CirclePhase der Animation ab
    switch (circlePhase) {
      case CirclePhase.growing:
        tween = Tween<double>(begin: radius, end: radius * 2);
        break;
      case CirclePhase.shrinking:
        tween = Tween<double>(begin: radius * 2, end: radius);
        break;
      case CirclePhase.holdIn:
        tween = Tween<double>(begin: radius * 2, end: radius * 2);
        break;
      case CirclePhase.holdOut:
        tween = Tween<double>(begin: radius, end: radius);
        break;
    }

    // erstellt eine TweenSequenceItem mit dem Tween und der Dauer
    // und gibt diese dann zurück
    return TweenSequenceItem(tween: tween, weight: durationInSeconds);
  }
}
