// ignore_for_file: prefer_const_constructors

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
