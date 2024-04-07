// ignore_for_file: prefer_const_constructors

import 'package:breathe/controller/animated_circle_controller.dart';
import 'package:breathe/cubits/home_cubit.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/datamodels/settings.dart';
import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/pages/play_breathing_page.dart';
import 'package:breathe/viewmodels/home_data.dart';
import 'package:breathe/widgets/circle.dart';
import 'package:breathe/widgets/home_bottom_navigation_bar.dart';
import 'package:breathe/widgets/inner_circle.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// TickerProviderStateMixin brauchen wir, damit die
// App merkt, dass Zeit vergeht und die Animation läuft
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, StyledAppBarMixin {
  // der Controller beinhaltet unter anderem das Starten der Animation
  final AnimatedCircleController _animatedCircleController =
      AnimatedCircleController();
  // Controller, um auf die HiveBox zuzugreifen
  final PresetsController _presetsController = GetIt.I<PresetsController>();
  late Preset? startingPreset;
  // die gesamte Wachsen und Schrumpfen Animation an sich
  late Animation<double> _gesamtAnimation;
  // Variable, damit das Wording von Tooltip und Text
  // gleich ist
  final String startBreathingText = 'Start Breathing';
  bool isLoading = true;

  @override
  void initState() {
    // laden der Start Animation
    _animatedCircleController.initState(ticker: this);
    initPresetsAndAnimation();

    // Initialisierung der Oberklasse
    super.initState();
  }

  void initPresetsAndAnimation() {
    // init des Hive Controllers
    _presetsController.initState();

    // lese den ersten Preset aus, der als Start-Preset markiert ist
    // und der einen Key besitzt
    var startFromList = _presetsController.animationPresets
        .firstWhere((element) => element.key is String && element.isStart);

    // falls ein Start-Preset in der Liste gefunden wurde
    if (startFromList is Preset) {
      _animatedCircleController.updatePreset(
          preset: startFromList, ticker: this);
      startingPreset = startFromList;
    } else {
      // ansonsten lese das Start Preset direkt aus dem Controller
      startingPreset = _presetsController.startingPreset;
    }

    // berechne die Animation
    _gesamtAnimation = _animatedCircleController.animateCirclePhases();

    // Damit die Animation wieder von vorn anfängt,
    // wenn sie einmal durchgelaufen ist
    _animatedCircleController.repeat();

    isLoading = false;
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
      body: BlocBuilder<HomeCubit, HomeData>(
        builder: (BuildContext context, HomeData state) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ein kleiner Abstand nach oben
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                height: 30.h,
                // Kreis Progress Indicator, solange die Start-Animation noch geladen wird
                child: Visibility(
                  visible: isLoading == false,
                  replacement:
                      SizedBox(width: 30.h, child: CircularProgressIndicator()),
                  child: AnimatedBuilder(
                    // die GesamtAnimation als double
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
                // VisualDensity beeinflusst den Abstand zwischen
                // IconButton, SizedBox und dem Text darunter.
                // Compact verringert den Abstand.
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PlayBreathingPage(presetKey: startingPreset?.key),
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
      ),
      // ButtomNavigationBar ausgelagert in ein eigenes Widget
      bottomNavigationBar: HomeButtonNavigationBar(),
    );
  }
}
