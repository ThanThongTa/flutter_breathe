import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/settings.dart';
import 'package:breathe/interfaces/breathing_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Klasse zum Verwalten der Kreis Animation
class AnimatedCircleController extends BreathingAnimationController {
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
  void initState({required TickerProvider ticker, Preset? preset}) {
    activePreset = preset;
    _animationController = AnimationController(
      duration: Duration(seconds: getCurrentTotalDurationTime()),
      // vsync erwartet einen TickerProvider
      vsync: ticker,
    );
  }

  // aktualisiert das aktive Preset und auch die Gesamtdauer der Animation
  void updatePreset({required TickerProvider ticker, required Preset preset}) {
    activePreset = preset;
    _animationController.duration =
        Duration(seconds: getCurrentTotalDurationTime());
  }

// startet und wiederholt die Animation
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
    // erstellt eine Liste von TweenSequenceItems für das aktuelle Preset
    List<TweenSequenceItem<double>> items = getCurrentAnimatedCirclePhases();
    // hängt die Items an den Controller
    //! ACHTUNG! animate nimmt den PARENT als Parameter
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
  // und verwendet sie als Werte für die Duration der
  // einzelnen Phasen in Sekunden
  int getTotalDurationTime(List<TweenSequenceItem<double>> items) {
    double durationInSeconds = 0;
    for (var item in items) {
      durationInSeconds += item.weight;
    }
    // Cast nach int ist notwendig, weil Weight als double angegeben wird
    // Duration allerdings in int angegeben werden muss
    return durationInSeconds.toInt();
  }

  // Null Safe Methode, um an die Durations zu kommen
  Map<CirclePhase, double> getLocalDurations(Preset? preset) {
    // verwenden von lokalen Variablen für die Type Promotion
    // damit ich nicht mit ! und ? Null Checks machen muss
    var activePresetLocal = preset;
    if (activePresetLocal is Preset) {
      var durationsLocal = activePresetLocal.durationsInSeconds;
      if (durationsLocal is Map<CirclePhase, double>) {
        return durationsLocal;
      } else {
        return {};
      }
    } else {
      return {};
    }
  }

  // ermittelt die gesamte Dauer der Animation für die aktuelle Gesamtanimation
  int getCurrentTotalDurationTime() {
    double sum = 0;
    for (var element in getLocalDurations(activePreset).entries) {
      sum += element.value;
    }
    if (sum == 0) sum = 4; // Wenn es kein active Preset gibt, ist die Dauer 4
    return sum.toInt();
  }

  // liest die Dauer der Animation für eine bestimmte Phase aus
  // gibt 1.0 zurück, falls keine Dauer gefunden werden konnte
  double getDurationInSecondsForPhase({required CirclePhase circlePhase}) {
    return getLocalDurations(activePreset)[circlePhase] ?? 1.0;
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
