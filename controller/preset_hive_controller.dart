// übernimmt das Speichern und Laden der Presets aus Hive
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:hive_flutter/hive_flutter.dart';

// der Controller für die Hive Boxen
class PresetHiveController implements PresetsController {
  // Die Namen der Hive Boxen, statisch, um Rechtschreibfehler
  // und ähnliches in den verschiedenen Klassen zu vermeiden
  static const hiveBoxKey = "AnimationPresets";
  static const startingPresetKey = "StartingPreset";

  // Variablen, um Daten aus den Hive Boxen zu speichern
  @override
  List animationPresets = [];
  @override
  late Preset? startingPreset;

  // Default Constructor
  PresetHiveController();

  // Öffnen der Hive Boxen
  var meinePresetsBox = Hive.box(hiveBoxKey);
  var startingPresetBox = Hive.box(startingPresetKey);

  @override
  void initState() {
    // versuche Daten aus der Hive Box zu lesen. Wenn keine vorhanden sind,
    // erstelle die Initialdaten, und speichere sie in die Hive Box
    if (meinePresetsBox.get(PresetHiveController.hiveBoxKey) == null) {
      createInitialData();
      updatePresetsInHive();
    }
    // versuche das gleiche mit der anderen Hive Box
    if (startingPresetBox.get(PresetHiveController.startingPresetKey) == null) {
      createInitialData();
      updateStartingPresetInHive();
    }
    // in jedem Fall lade die Daten aus der Hive Box
    loadPresetsFromHive();
    loadStartingPresetFromHive();
  }

  @override
  List initPresets(String? presetKey) {
    if (meinePresetsBox.get(PresetHiveController.hiveBoxKey) == null) {
      createInitialData();
      updatePresetsInHive();
      updateStartingPresetInHive();
      loadPresetsFromHive();
      loadStartingPresetFromHive();
    }

    var temp = meinePresetsBox.get(PresetHiveController.hiveBoxKey);
    // falls die Box immer noch nicht geladen werden
    // nimm einfach die Liste aus dem Controller
    if (temp == null || temp.isEmpty) {
      return animationPresets;
    } else {
      // ansonsten nehme die Liste aus der Hive Box
      return temp;
    }
  }

  // Initialdaten für die Hive-Box
  void createInitialData() {
    animationPresets = [
      Preset(
        name: 'Preset 1',
        durationsInSeconds: {
          CirclePhase.growing: 4,
          CirclePhase.holdIn: 4,
          CirclePhase.shrinking: 4,
          CirclePhase.holdOut: 4
        },
        key: 'another_preset_1',
      ),
      Preset(name: 'Default Preset', key: 'preset_1'),
      Preset(
          name: 'Custom 1',
          durationsInSeconds: {
            CirclePhase.growing: 3,
            CirclePhase.holdIn: 2,
            CirclePhase.shrinking: 3,
            CirclePhase.holdOut: 2
          },
          key: 'preset_2'),
      Preset(
          name: 'Preset with Texts',
          texts: {
            CirclePhase.growing: 'Inhale slowly',
            CirclePhase.holdIn: 'Hold your breath',
            CirclePhase.shrinking: 'Exhale gently',
            CirclePhase.holdOut: 'Empty your lungs'
          },
          key: 'preset_3'),
      Preset(
          name: 'Preset with Retention',
          hasRetention: true,
          breathsBeforeRetention: 5,
          selectedBreathSpeedBeforeRetention: 4,
          key: 'preset_4'),
      Preset(name: 'Favorite Preset', isFavorite: true, key: 'preset_5'),
      Preset(
          name: 'All Phases and Texts',
          durationsInSeconds: {
            CirclePhase.growing: 4,
            CirclePhase.holdIn: 3,
            CirclePhase.shrinking: 4,
            CirclePhase.holdOut: 3
          },
          texts: {
            CirclePhase.growing: 'Inhale deeply',
            CirclePhase.holdIn: 'Hold your breath',
            CirclePhase.shrinking: 'Exhale completely',
            CirclePhase.holdOut: 'Relax and pause'
          },
          key: 'preset_6'),
      Preset(name: 'Preset with Skip Holds', skipHolds: true, key: 'preset_7'),
      Preset(
          name: 'Start Preset',
          isStart: true,
          breathsBeforeRetention: 3,
          key: 'preset_8'),
      Preset(
          name: 'Customized Texts and Durations',
          durationsInSeconds: {
            CirclePhase.growing: 2,
            CirclePhase.holdIn: 1,
            CirclePhase.shrinking: 2,
            CirclePhase.holdOut: 1
          },
          texts: {
            CirclePhase.growing: 'Breathe in',
            CirclePhase.holdIn: 'Hold',
            CirclePhase.shrinking: 'Breathe out',
            CirclePhase.holdOut: 'Rest'
          },
          key: 'preset_9'),
      Preset(
          name: 'Customized Preset',
          durationsInSeconds: {
            CirclePhase.growing: 5,
            CirclePhase.holdIn: 4,
            CirclePhase.shrinking: 5,
            CirclePhase.holdOut: 4
          },
          texts: {
            CirclePhase.growing: 'Inhale deeply',
            CirclePhase.holdIn: 'Hold your breath',
            CirclePhase.shrinking: 'Exhale slowly',
            CirclePhase.holdOut: 'Relax and breathe'
          },
          breathsBeforeRetention: 6,
          hasRetention: true,
          selectedBreathSpeedBeforeRetention: 5,
          key: 'preset_10'),
    ];
    // startingPreset = animationPresets.first;
  }

  // Presets aus der Hive-Box laden
  @override
  void loadPresetsFromHive() {
    animationPresets = meinePresetsBox.get(hiveBoxKey) ?? [];
  }

  // Presets in die Hive-Box speichern
  @override
  void updatePresetsInHive() {
    meinePresetsBox.put(hiveBoxKey, animationPresets);
  }

  // Starting Preset aus der Hive-Box laden
  void loadStartingPresetFromHive() {
    var temp = startingPresetBox.get(startingPresetKey);
    // wenn bereits ein Start-Preset in der Hive Box gespeichert wurde
    if (temp is Preset) {
      startingPreset = temp;
    } else {
      // wenn noch kein Start-Preset gespeichert wurde, lade das erste
      // aus den Animation-Presets
      startingPreset =
          animationPresets.firstWhere((element) => element.key is String);
    }
  }

  // Starting Preset in die Hive-Box speichern
  void updateStartingPresetInHive() {
    startingPresetBox.put(startingPresetKey, startingPreset);
  }
}
