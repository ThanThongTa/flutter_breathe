// ignore_for_file: prefer_const_constructors

import 'package:breathe/controller/animated_circle_controller.dart';
import 'package:breathe/controller/preset_hive_controller.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/datamodels/settings.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/pages/play_breathing_page.dart';

import 'package:breathe/widgets/circle.dart';
import 'package:breathe/widgets/home_bottom_navigation_bar.dart';
import 'package:breathe/widgets/inner_circle.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

// Home ist der Startbildschirm. Bei jedem Neustart und nach jeder
// Breathing- bzw. Meditations-Session wird dieser Screen angezeigt.
// Angezeigt wird ein animierter Kreis, ein Startbutton mit Text,
// und eine ButtomNavigationBar.

// Von hier aus gelangt man über den Startbutton direkt in den Breathing-Screen
// und startet eine Breathing Session mit dem ausgesuchten Start-Preset.

// ÜBer die ButtomNavigationBar gelangt man außerdem über "Breathing"
// zu einer Seite, auf der man das verwendete Preset für die Breathing-Session
// anpassen kann.
// Über Retention gelangt man zu einer Seite extra für Retention Presets.
// Über Meditation gelangt man zu einer Seite mit einer Liste von geführten
// Meditationen.
// Und über Favorites gelangt man zu einer Seite mit einer Liste von
// als Favorit markierten Presets und Meditationen.

//TODO: Home Page erstellen als BlocProvider
//TODO: HomeScreen umschreiben als BlocBuilder
//TODO: Key für den PlayButton auslesen und implementieren

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// SingleTickerProviderStateMixin brauchen wir, damit die
// App merkt, dass Zeit vergeht und die Animation läuft
class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, StyledAppBarMixin {
  // der Controller beinhaltet unter anderem das Starten der Animation
  final AnimatedCircleController _animatedCircleController =
      AnimatedCircleController();
  // Controller, um auf die HiveBox zuzugreifen
  final PresetHiveController _presetHiveController = PresetHiveController();
  late Preset startingPreset;
  // die gesamte Wachsen und Schrumpfen Animation an sich
  late Animation<double> _gesamtAnimation;
  // Variable, damit das Wording von Tooltip und Text
  // gleich ist
  final String startBreathingText = 'Start Breathing';
  // Box für das Starting Preset
  var startingPresetBox = Hive.box(PresetHiveController.startingPresetKey);
  bool isLoading = true;

  @override
  void initState() {
    initAsync();

    // während noch gewartet wird
    Preset temp = Preset(
      name: 'Temp Preset 1',
      key: 'temp_preset_1',
      durationsInSeconds: {
        CirclePhase.growing: 1,
        CirclePhase.holdIn: 1,
        CirclePhase.shrinking: 1,
        CirclePhase.holdOut: 1
      },
    );

    // laden der Start Animation
    _animatedCircleController.initState(ticker: this, preset: temp);

    // die Animation muss später im AnimationBuilder angegeben werden
    _gesamtAnimation = _animatedCircleController.animateCirclePhases();

    // Initialisierung der Oberklasse
    super.initState();
  }

  void initAsync() async {
    // init des Hive Controllers
    await _presetHiveController.initState();
    // kein Starting Preset gefunden
    if (startingPresetBox.get(PresetHiveController.startingPresetKey) == null) {
      // Presets neu erstellen und in die HiveBox und in den Controller laden
      isLoading = true;
      _presetHiveController.createInitialData();
      _presetHiveController.updatePresetsInHive();
      _presetHiveController.updateStartingPresetInHive();
      _presetHiveController.loadPresetsFromHive();
      _presetHiveController.loadStartingPresetFromHive();

      // StartingPreset aus der HiveBox laden
      var temp = startingPresetBox.get(PresetHiveController.startingPresetKey);
      setState(() {
        // falls die Box immer noch nicht geladen werden konnte
        if (temp == null) {
          // StartingPreset aus dem Controller laden
          startingPreset = _presetHiveController.startingPreset;
        } else {
          // ansonsten verwende das geladene StartingPreset
          startingPreset = temp;
        }
        isLoading = false;
        _animatedCircleController.updatePreset(
            preset: startingPreset, ticker: this);
        _gesamtAnimation = _animatedCircleController.animateCirclePhases();
      });
    } else {
      // falls das Starting Preset geladen werden konnte
      setState(() {
        // verwende das geladene StartingPreset und setze den isLoading auf false
        // damit der Lade-Kreis nicht mehr angezeigt wird
        isLoading = false;
        startingPreset =
            startingPresetBox.get(PresetHiveController.startingPresetKey);
        // aktualisiere die Animation mit dem neuen StartingPreset
        _animatedCircleController.updatePreset(
            preset: startingPreset, ticker: this);
        _gesamtAnimation = _animatedCircleController.animateCirclePhases();
      });
    }

    // Damit die Animation wieder von vorn anfängt,
    // wenn sie einmal durchgelaufen ist
    _animatedCircleController.repeat();
  }

  @override
  void dispose() {
    // dispose der Controller
    _animatedCircleController.dispose();
    // Dispose der Oberklasse
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // getStyledAppBar kommt aus dem StyledAppBarMixin
      appBar: getStyledAppBar(context, title: 'Breathe'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 5.h,
            ),
            SizedBox(
              height: 30.h,
              child: Visibility(
                visible: isLoading == false,
                replacement:
                    SizedBox(width: 30.h, child: CircularProgressIndicator()),
                child: AnimatedBuilder(
                  animation: _gesamtAnimation,
                  builder: (context, child) {
                    return Circle(
                      // der Value ändert sich mit der Zeit,
                      // so kommt die Animation zustande
                      radius: _gesamtAnimation.value,
                      color: Settings.defaultThemeColor,
                      // child ist der Inhalt des Circles
                      child: InnerCircle(),
                    );
                  },
                ),
              ),
            ),
            // SizedBox für den Abstand zwischen dem animierten Kreis
            // und dem Startbutton
            SizedBox(
              height: 15.h,
            ),
            // Icon, um mit dem Breathing anzufangen
            // navigiert direkt zu der Breathing Seite
            // anstatt vorher zum Edit Breathing
            IconButton(
              // beeinflusst den Abstand zwischen IconButton,
              // SizedBox und dem Text darunter. Compact
              // verringert den Abstand.
              visualDensity: VisualDensity.compact,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayBreathingPage(),
                  ),
                );
              },
              icon: Icon(Icons.play_circle_outline),
              tooltip: startBreathingText,
              color: Settings.defaultThemeColor,
              iconSize: 16.w,
            ),
            // Text, damit auch klar ist, wofür das Icon ist
            Text(
              startBreathingText,
              style: TextStyle(color: Settings.defaultThemeColor),
            ),
          ],
        ),
      ),
      // ButtomNavigationBar ausgelagert in ein eigenes Widget
      bottomNavigationBar: HomeButtonNavigationBar(),
    );
  }
}
