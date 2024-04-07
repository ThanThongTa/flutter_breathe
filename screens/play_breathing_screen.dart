// ignore_for_file: prefer_const_constructors

import 'package:breathe/cubits/play_breathing_cubit.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/extensions/context_extensions.dart';
import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/viewmodels/play_breathing_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

//TODO: Load selected Preset from Hive
//TODO: Add Circle Animation
//TODO: Start and Stop Animation
//TODO: Finish Session, go back to Home

//TODO: show texts for circle phases, if showText is true
// maybe use flutter_animate with delay for texts, and then()
// maybe use Timer with delay for texts
// maybe animatedSwitch?
// maybe ValueListener and ValueNotifier?
//TODO: show Count inside of animated circle, if true
// maybe create own animation widgets

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
  // Controller, um auf die Presets zuzugreifen
  final PresetsController _presetsController = GetIt.I<PresetsController>();

  Preset? currentPreset; // null, wenn ein neues Preset erstellt wird
  List presets = [];

  @override
  void initState() {
    _presetsController.initState();

    // falls kein Preset Key angegeben wurde, braucht auch kein Preset
    // geladen zu werden
    if (widget.presetKey == null) {
      currentPreset = null;
      super.initState();
      return;
    }

    presets = _presetsController.initPresets(widget.presetKey);
    currentPreset =
        presets.firstWhere((element) => element.key == widget.presetKey);

    if (currentPreset is Preset) {
      context.playBreathingCubit.setDataFromPreset(preset: currentPreset!);
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
