import 'package:breathe/datamodels/preset.dart';

// als Interface zur Abstraktion vom PresetHiveController
// damit man theoretisch auch andere Datenbanken
// oder für Mocking und Tests auch Stubs verwenden kann
abstract class PresetsController {
  void initState();
  List initPresets(String? presetKey);
  List animationPresets = [];
  Preset? startingPreset;
  void updatePresetsInHive();
  void loadPresetsFromHive();
}
