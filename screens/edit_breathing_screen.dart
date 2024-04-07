// ignore_for_file: prefer_const_constructors

import 'package:breathe/extensions/context_extensions.dart';
import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/cubits/edit_breathing_cubit.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/pages/preset_list_page.dart';
import 'package:breathe/viewmodels/edit_breathing_data.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/widgets/labeled_checkbox_row.dart';
import 'package:breathe/widgets/labelled_number_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// TODO: Beispiel-Animation hinzufügen, damit der User die Effekte seiner Auswahl direkt sehen kann
// TODO: Formular hübscher machen, Buttons/Switches anstatt Checkboxes, DropdownLists anstatt NumberPicker? Slider für Zahlen?
// TODO: AlertDialog für Speichern hinzufügen

// EditBreathingScreen ist die Seite, auf der man ein neues Breathing-Preset
// erstellen oder auch ein bestehendes Preset bearbeiten kann
// man kommt vom Home Screen hierhin. Beim erfolgreichen Speichern wird auf
// die Preset List Seite weiter geleitet.
class EditBreathingScreen extends StatefulWidget {
  final String? presetKey;
  const EditBreathingScreen({super.key, this.presetKey});

  @override
  State<EditBreathingScreen> createState() => _EditBreathingScreenState();
}

class _EditBreathingScreenState extends State<EditBreathingScreen>
    with StyledAppBarMixin {
  // Controller, um die Textfelder initial mit Text befüllen zu können
  final PresetsController _presetsController = GetIt.I<PresetsController>();
  late TextEditingController presetNameTextController = TextEditingController();
  late TextEditingController growingTextController = TextEditingController();
  late TextEditingController shrinkingTextController = TextEditingController();
  late TextEditingController holdInPhaseTextController =
      TextEditingController();
  late TextEditingController holdOutPhaseTextController =
      TextEditingController();

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

    // ansonsten lade das gewählte Preset aus der Hive Box
    presets = _presetsController.initPresets(widget.presetKey);

    // das aktuelle Preset setzen auf das erste mit dem richtigen Key
    currentPreset =
        presets.firstWhere((element) => element.key == widget.presetKey);

    // falls ein Preset mit diesem Key gefunden werden konnte
    // aktualisiere den State und die angezeigten Eingabefelder
    if (currentPreset is Preset) {
      context.editBreathingCubit.setDataFromPreset(preset: currentPreset!);
    }

    // setze die Initial-Texte für die Textfelder
    presetNameTextController.text = currentPreset?.name ?? '';
    growingTextController.text =
        currentPreset?.texts?[CirclePhase.growing] ?? '';
    holdInPhaseTextController.text =
        currentPreset?.texts?[CirclePhase.holdIn] ?? '';
    holdOutPhaseTextController.text =
        currentPreset?.texts?[CirclePhase.holdOut] ?? '';
    shrinkingTextController.text =
        currentPreset?.texts?[CirclePhase.shrinking] ?? '';

    super.initState();
  }

  // ein neues Preset wird erstellt, wenn kein Key angegeben wurde
  void saveNewPreset() {
    context.editBreathingCubit.removeUniqueKey();
    var newKey = UniqueKey().toString();
    context.editBreathingCubit.setUniqueKey(newKey);
    savePreset();
  }

  // speichert die aktuell angezeigten Daten in einem Preset
  void savePreset() {
    // speichert das aktuelle Preset in der HiveBox
    // Verwendung von Cubits, um die Businesslogik von der Präsentation
    // zu trennen
    context.editBreathingCubit.savePreset(controller: _presetsController);

    // ruft die Update Funktion auf, um die Presets in die HiveBox zu speichern
    _presetsController.updatePresetsInHive();

    // gibt eine Erfolgsnachricht aus

    context.showSnackBar(snackBarWithSuccessfulSaveMessage);

    // Navigiert dann zum PresetListScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PresetListPage(),
      ),
    );
  }

  // Snackbar mit der Fehlermeldung, dass Preset einen Namen haben muss
  SnackBar snackBarWithPresetNameErrorMessage = SnackBar(
    content: Center(
      child: Text(
        "Preset muss einen Namen haben",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );

  // Snackbar mit der Erfolgsnachricht, dass das Preset erfolgreich
  // gespeichert werden konnte
  SnackBar snackBarWithSuccessfulSaveMessage = SnackBar(
    content: Center(
      child: Text(
        "Preset erfolgreich gespeichert",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    ),
  );

  // Ja, das ist ein langer Code-Block, aber an sich gar nicht so kompliziert
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Edit Breathing'),
      // BlocBuilder sorgt dafür, dass die Cubit und Data verwendet werden können
      body: BlocBuilder<EditBreathingCubit, EditBreathingData>(
        // state ist das Objekt, mit dem wir arbeiten
        builder: (context, state) => SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Hier beginnt das eigentliche Formular
                children: [
                  // Dr unique key wird nur für debug zwecke angezeigt
                  // TODO: Nach der Debugphase diese Zeile entfernen
                  Text('Unique key of the preset is: ${state.key}'),
                  // Textfeld mit dem Namen des Presets
                  TextField(
                    controller: presetNameTextController,
                    onChanged: (value) =>
                        context.editBreathingCubit.setPresetNameText(value),
                    decoration:
                        InputDecoration(labelText: 'Name of the preset'),
                  ),
                  // eine Gruppe von Checkboxes. Angefangen mit der Checkbox
                  // für showTexts.
                  LabeledCheckboxRow(
                    label: "Show Texts in animation: ",
                    value: state.showTexts,
                    semanticLabel: "Show texts for breathing phases?",
                    onChanged: (newValue) =>
                        context.editBreathingCubit.toggleShowTexts(newValue),
                    // Wenn ich GetIt verwende, kommt der Klick nicht mehr an
                    // TODO: Recherche, warum das mit GetIt nicht funktioniert
                    // Vielleicht brauchen wir doch Bloc anstatt Cubits
                    // onChanged: (newValue) =>
                    //     GetIt.I<EditBreathingCubit>().toggleShowTexts(newValue),
                  ),
                  // checkbox für showCount
                  LabeledCheckboxRow(
                    label: "Show Count in animation: ",
                    value: state.showCount,
                    semanticLabel: "Show count in animation?",
                    onChanged: (newValue) =>
                        context.editBreathingCubit.toggleShowCount(newValue),
                  ),
                  // checkbox für skipHolds
                  LabeledCheckboxRow(
                    label: "Connected Breathing: ",
                    value: state.skipHolds,
                    semanticLabel: "Skip holds in animation?",
                    onChanged: (newValue) =>
                        context.editBreathingCubit.toggleSkipHolds(newValue),
                  ),
                  // checkbox für isStart
                  LabeledCheckboxRow(
                    label: "Set as starting preset after save: ",
                    value: state.isStart,
                    semanticLabel: "Set as starting preset after save?",
                    onChanged: (newValue) =>
                        context.editBreathingCubit.toggleIsStart(newValue),
                  ),
                  // checkbox für isFavorite
                  LabeledCheckboxRow(
                    label: "Set as favorite after save: ",
                    value: state.isFavorite,
                    semanticLabel: "Set as favorite after save?",
                    onChanged: (newValue) =>
                        context.editBreathingCubit.toggleIsFavorite(newValue),
                  ),
                  // Textfeld mit dem Text für die Growing Phase
                  // nur sichtbar, wenn Texte angezeigt werden
                  Visibility(
                    visible: state.showTexts,
                    child: TextField(
                      controller: growingTextController,
                      onChanged: (value) =>
                          context.editBreathingCubit.setGrowingPhaseText(value),
                      decoration: InputDecoration(
                          labelText: 'Text for the growing phase'),
                    ),
                  ),
                  // Number Picker für die Duration der Growing Phase
                  LabelledNumberPicker(
                    label: "Duration of Growing Phase in Seconds: ",
                    value: state.growingPhaseDurationInSeconds,
                    onChanged: (value) => context.editBreathingCubit
                        .setGrowingPhaseDurationInSeconds(value),
                  ),
                  // Textfeld mit dem Text für die Hold In Phase
                  // nur sichtbar, wenn Texte angezeigt werden
                  // und wenn Connected Breathing nicht aktiv ist
                  Visibility(
                    visible: state.showTexts && state.skipHolds == false,
                    child: TextField(
                      controller: holdInPhaseTextController,
                      onChanged: (value) =>
                          context.editBreathingCubit.setHoldInPhaseText(value),
                      decoration: InputDecoration(
                          labelText: 'Text for the hold In phase'),
                    ),
                  ),
                  // Number Picker für die Duration der Hold In Phase
                  // nur sichtbar, wenn Connected Breathing nicht aktiv ist
                  Visibility(
                    visible: state.skipHolds == false,
                    child: LabelledNumberPicker(
                      label: "Duration of Hold in Phase in Seconds: ",
                      value: state.holdInPhaseDurationInSeconds,
                      onChanged: (value) => context.editBreathingCubit
                          .setHoldInPhaseDurationInSeconds(value),
                    ),
                  ),
                  // Textfeld mit dem Text für die Shrinking Phase
                  // nur sichtbar, wenn Texte angezeigt werden
                  Visibility(
                    visible: state.showTexts,
                    child: TextField(
                      controller: shrinkingTextController,
                      onChanged: (value) => context.editBreathingCubit
                          .setShrinkingPhaseText(value),
                      decoration: InputDecoration(
                          labelText: 'Text for the Shrinking phase'),
                    ),
                  ),
                  // Number Picker für die Duration der Shrinking Phase
                  LabelledNumberPicker(
                    label: "Duration of Shrinking Phase in Seconds: ",
                    value: state.shrinkingPhaseDurationInSeconds,
                    onChanged: (value) => context.editBreathingCubit
                        .setShrinkingPhaseDurationInSeconds(value),
                  ),
                  // Textfeld mit dem Text für die Hold Out Phase
                  // nur sichtbar, wenn Texte angezeigt werden
                  // und wenn Connected Breathing nicht aktiv ist
                  Visibility(
                    visible: state.showTexts && state.skipHolds == false,
                    child: TextField(
                      controller: holdOutPhaseTextController,
                      onChanged: (value) =>
                          context.editBreathingCubit.setHoldOutPhaseText(value),
                      decoration: InputDecoration(
                          labelText: 'Text for the hold out phase'),
                    ),
                  ),
                  // Number Picker für die Duration der Hold Out Phase
                  // nur sichtbar, wenn Connected Breathing nicht aktiv ist
                  Visibility(
                    visible: state.skipHolds == false,
                    child: LabelledNumberPicker(
                      label: "Duration of Hold out Phase in Seconds: ",
                      value: state.holdOutPhaseDurationInSeconds,
                      onChanged: (value) => context.editBreathingCubit
                          .setHoldOutPhaseDurationInSeconds(value),
                    ),
                  ),
                  // Button zum Speichern des Presets als neues Preset
                  ElevatedButton(
                    onPressed: () {
                      if (state.presetNameText.isEmpty) {
                        context
                            .showSnackBar(snackBarWithPresetNameErrorMessage);
                        return;
                      }

                      saveNewPreset();
                    },
                    child: Text('Save as a new preset'),
                  ),
                  // Button zum Speichern eines existierenden Presets
                  // falls das Preset noch nicht exisitiert, wird ein
                  // neuees Preset erstellt
                  ElevatedButton(
                    onPressed: () {
                      if (state.presetNameText.isEmpty) {
                        context
                            .showSnackBar(snackBarWithPresetNameErrorMessage);
                        return;
                      }
                      savePreset();
                    },
                    child: Text('save preset'),
                  ),
                  // generiert einen neuen UniqueKey und speichert es im State
                  ElevatedButton(
                    onPressed: () {
                      var newKey = UniqueKey().toString();
                      state.key = newKey;
                      context.editBreathingCubit.setUniqueKey(newKey);
                    },
                    child: Text('Generate new UniqueKey'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
