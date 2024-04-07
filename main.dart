// ignore_for_file: prefer_const_constructors

// in pubspec:
//
// dependencies:
//  flutter:
//    sdk: flutter
//  sizer: ^2.0.15 # Sizer für Responsive Design
//  hive: ^2.2.3
//  hive_flutter: ^1.1.0 # Hive und HiveFlutter, um Daten zu speichern
//  numberpicker: ^2.1.2 # ein etwas hübscherer Picker für Nummern
//  bloc: ^8.1.0
//  flutter_bloc: ^8.1.5 # Bloc und flutter_bloc, um die BusinessLogic von der Präsentation zu trennen
//  get_it: ^7.6.8 # Service Locator, um mit Singletons zu arbeiten
//  flutter_slidable: ^3.1.0 # Slidables für die Liste der Presets
//  collection: ^1.18.0

//  dev_dependencies:
//  flutter_test:
//    sdk: flutter
//  flutter_lints: ^3.0.0
//  build_runner: ^2.4.9
//  hive_generator: ^2.0.1

import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/controller/preset_hive_controller.dart';
import 'package:breathe/cubits/edit_breathing_cubit.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

void main() async {
  //debugRepaintRainbowEnabled = true;
  // Initialisierung von Hive
  await Hive.initFlutter(); // Hive_flutter importieren

  // Adapter für die Presets registrieren
  Hive.registerAdapter(PresetAdapter());
  // auch enums brauchen einen Adapter
  Hive.registerAdapter(CirclePhaseAdapter());
  // öffnen der Hive Boxen
  await Hive.openBox(PresetHiveController.hiveBoxKey);
  await Hive.openBox(PresetHiveController.startingPresetKey);
  // Da PresetHiveController eine geöffnete HiveBox verwendet,
  // sollte die Init nach dem Öffnen der Boxen passieren
  GetIt.I.registerSingleton<PresetsController>(PresetHiveController());
  GetIt.I.registerSingleton<EditBreathingCubit>(EditBreathingCubit());

  // eigentliche App starten
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sizer für responsive Design
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        // Entferne den debug Banner
        debugShowCheckedModeBanner: false,

        title: 'Breathe',
        // erstelle einen Theme auf Basis der SeedColor indigo
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          useMaterial3: true,
        ),
        // Startbildschirm ist home.dart
        home: HomePage(),
      );
    });
  }
}
