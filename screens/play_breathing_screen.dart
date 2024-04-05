// ignore_for_file: prefer_const_constructors

import 'package:breathe/controller/preset_hive_controller.dart';
import 'package:breathe/cubits/play_breathing_cubit.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/viewmodels/play_breathing_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

//TODO: Load selected Preset from Hive
//TODO: Add Circle Animation
//TODO: Start and Stop Animation
//TODO: Finish Session, go back to Home

// auf dem PlayBreathingScreen wird das ausgewählte Preset als Animation
// abgespielt. Der User kann die Animation stoppen und wieder fortsetzen.
// Der User kann die Session auch beenden. Er landet dann wieder im Home
// Screen.
class PlayBreathingScreen extends StatefulWidget with StyledAppBarMixin {
  final String? presetKey;
  const PlayBreathingScreen({
    super.key,
    this.presetKey,
  });

  @override
  State<PlayBreathingScreen> createState() => _PlayBreathingScreenState();
}

class _PlayBreathingScreenState extends State<PlayBreathingScreen>
    with StyledAppBarMixin {
  // Controller, um auf die HiveBox zuzugreifen
  final PresetHiveController _presetHiveController = PresetHiveController();
  var presetsBox = Hive.box(PresetHiveController.hiveBoxKey);
  Preset? currentPreset; // null, wenn ein neues Preset erstellt wird
  List presets = [];

  @override
  void initState() {
    _presetHiveController.initState();

    // falls kein Preset Key angegeben wurde, braucht auch kein Preset
    // geladen zu werden
    if (widget.presetKey == null) {
      currentPreset = null;
      super.initState();
      return;
    }

    // ansonsten lade das gewählte Preset aus der Hive Box
    if (presetsBox.get(PresetHiveController.hiveBoxKey) == null) {
      _presetHiveController.createInitialData();
      _presetHiveController.updatePresetsInHive();
      _presetHiveController.updateStartingPresetInHive();
      _presetHiveController.loadPresetsFromHive();
      _presetHiveController.loadStartingPresetFromHive();

      var temp = presetsBox.get(PresetHiveController.hiveBoxKey);
      // falls die Box immer noch nicht geladen werden
      // nimm einfach die Liste aus dem Controller
      if (temp == null) {
        presets = _presetHiveController.animationPresets;
        currentPreset =
            presets.firstWhere((element) => element.key == widget.presetKey);
      } else {
        // ansonsten nehme die Liste aus der Hive Box
        presets = temp;
        currentPreset =
            temp.firstWhere((element) => element.key == widget.presetKey);
      }
    } else {
      // falls die Hive Box geladen werden konnte
      presets = presetsBox.get(PresetHiveController.hiveBoxKey);
      if (presets.isEmpty) {
        presets = _presetHiveController.animationPresets;
      } else {
        currentPreset =
            presets.firstWhere((element) => element.key == widget.presetKey);
      }
    }

    if (currentPreset != null) {
      context
          .read<PlayBreathingCubit>()
          .setDataFromPreset(preset: currentPreset!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Breathing'),
      body: BlocBuilder<PlayBreathingCubit, PlayBreathingData>(
        builder: (BuildContext context, PlayBreathingData state) => Center(
          child: Text('Hello Breathing World! from ${state.key}'),
        ),
      ),
    );
  }
}
