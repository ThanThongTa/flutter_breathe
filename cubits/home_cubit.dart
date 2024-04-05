import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/viewmodels/home_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit für die Business Logic des Homescreens
// hauptsächlich also für das Bestimmen des Starting Presets
class HomeCubit extends Cubit<HomeData> {
  HomeCubit() : super(HomeData());

  late Preset startingPreset;
  bool isInitialized = false;

  void initData() {
    startingPreset = Preset(name: 'Init', key: 'init_preset_1');
    isInitialized = true;
  }

  HomeData getCurrentData() {
    if (!isInitialized) {
      initData();
    }
    return HomeData(startingPreset: startingPreset);
  }

  void setStartingPreset(Preset preset) {
    var current = getCurrentData();
    startingPreset = preset;
    current.startingPreset = preset;
    emit(current);
  }
}
