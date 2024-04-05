import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/viewmodels/preset_list_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit für die Business Logic des PresetListScreens
// aktuelle Liste von Presets neu setzen, Preset löschen
class PresetListCubit extends Cubit<PresetListData> {
  PresetListCubit() : super(PresetListData());

  late List presets;

  bool isInitialized = false;

  void initData() {
    presets = [];
    isInitialized = true;
  }

  PresetListData getCurrentData() {
    if (!isInitialized) {
      initData();
    }
    return PresetListData(presets: presets);
  }

  // erhält eine Liste von Presets und ersetzt die aktuell gespeicherte
  // Liste mit dieser
  void setPresets({required List newPresets}) {
    var current = getCurrentData();
    presets = newPresets;
    current.presets = newPresets;
    emit(current);
  }

  // löscht ein bestimmtes Preset
  void deletePreset(Preset preset) {
    var current = getCurrentData();
    presets.remove(preset);
    current.presets.remove(preset);
    emit(current);
  }

  // löscht alle Presets mit einem bestimmten UniqueKey
  void deletePresetWithKey(String key) {
    var current = getCurrentData();
    presets.removeWhere((preset) => preset.key == key);
    current.presets.removeWhere((preset) => preset.key == key);
    emit(current);
  }
}
