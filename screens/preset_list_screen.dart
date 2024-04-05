// ignore_for_file: prefer_const_constructors

import 'package:breathe/controller/preset_hive_controller.dart';
import 'package:breathe/cubits/preset_list_cubit.dart';
import 'package:breathe/datamodels/settings.dart';
import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:breathe/pages/edit_breathing_page.dart';
import 'package:breathe/pages/play_breathing_page.dart';
import 'package:breathe/viewmodels/preset_list_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

// Auf dem Preset List Screen werden alle Presets aufgelistet.

// Man gelangt entweder vom Home Screen hierhin, oder nach dem man
// erfolgreich ein Preset gespeichert hat.

// Hier kann man Presets löschen, editieren, als Favoriten speichern,
// als Start Animation markieren, oder eine Breathing Session mit dem
// Preset starten.
class PresetListScreen extends StatefulWidget {
  const PresetListScreen({super.key});

  @override
  State<PresetListScreen> createState() => _PresetListScreenState();
}

class _PresetListScreenState extends State<PresetListScreen>
    with StyledAppBarMixin {
  // Hive Box für die gespeicherten Presets
  var presetsBox = Hive.box(PresetHiveController.hiveBoxKey);
  // Controller, um auf die HiveBox zuzugreifen
  final PresetHiveController _presetHiveController = PresetHiveController();
  // Variable für die gespeicherten Presets
  List presets = [];

  @override
  void initState() {
    // falls die Box nicht geöffnet werden kann, erstelle die Initialdaten
    // und speichere sie in der Box. Dann öffne die Box wieder.
    _presetHiveController.initState();

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
      } else {
        // ansonsten nehme die Liste aus der Hive Box
        presets = temp;
      }
    } else {
      // falls die Hive Box geladen werden konnte
      presets = presetsBox.get(PresetHiveController.hiveBoxKey);
      if (presets.isEmpty) {
        presets = _presetHiveController.animationPresets;
      }
    }

    // die Presets im State speichern und wieder auslesen
    context.read<PresetListCubit>().setPresets(newPresets: presets);
    presets = context.read<PresetListCubit>().getCurrentData().presets;

    super.initState();
  }

  // Öffnet das angegebene Preset im Edit Breathing Screen
  void navigateToEditBreathingPage({required String presetKey}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditBreathingPage(
            presetKey: presetKey,
          ),
        ));
  }

  // Öffnet das angegebene Preset im Play Breathing Screen
  void navigateToPlayBreathingPage({required String presetKey}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayBreathingPage(
            presetKey: presetKey,
          ),
        ));
  }

  // eine Snackbar mit Fehlermeldung
  SnackBar snackBarWithMissingKeyErrorMessage = SnackBar(
    content: Center(
      child: Text(
        "Unique Key fehlt.",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Preset List'),
      body: BlocBuilder<PresetListCubit, PresetListData>(
        builder: (BuildContext context, PresetListData state) => Center(
          child: Visibility(
            visible: state.presets.isNotEmpty,
            replacement: Text("No Presets found"),
            // der interessante Teil beginnt hier mit dem ListView Builder
            child: ListView.builder(
              itemCount: state.presets.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // Jedes Preset wird in einer eigenen Row dargestellt
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Settings.secondaryThemeColor,
                        child: Row(
                          // in der Reihe gibt es eine SizedBox für den Titel
                          children: [
                            SizedBox(
                              width: 50.w,
                              child: ListTile(
                                title: Text(state.presets[index].name),
                                titleTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            // und eine SizedBox für die Icons
                            SizedBox(
                              width: 45.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Edit Button
                                  IconButton(
                                    onPressed: () {
                                      var key = state.presets[index].key;
                                      if (key == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            snackBarWithMissingKeyErrorMessage);
                                        return;
                                      }

                                      navigateToEditBreathingPage(
                                          presetKey: key);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Play Button
                                  IconButton(
                                    onPressed: () {
                                      var key = state.presets[index].key;
                                      if (key == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            snackBarWithMissingKeyErrorMessage);
                                        return;
                                      }

                                      navigateToPlayBreathingPage(
                                          presetKey: key);
                                    },
                                    icon: Icon(Icons.play_circle_outline_sharp,
                                        color: Colors.white),
                                  ),
                                  // Delete Button
                                  IconButton(
                                    onPressed: () {
                                      var key = state.presets[index].key;
                                      if (key == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            snackBarWithMissingKeyErrorMessage);
                                        return;
                                      }
                                      context
                                          .read<PresetListCubit>()
                                          .deletePresetWithKey(key);
                                    },
                                    icon: Icon(Icons.delete_outline,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
