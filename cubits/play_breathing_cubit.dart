import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/viewmodels/play_breathing_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit für die Business Logic des PlayBreathingScreen
// auslesen aus einem übergebenen Preset und im State speichern
class PlayBreathingCubit extends Cubit<PlayBreathingData> {
  PlayBreathingCubit() : super(PlayBreathingData());
  // Variablen für aktuelle Daten aus der Hive Box
  late bool showTexts;
  late bool showCount;
  late bool skipHolds;
  late bool isFavorite;
  late bool isStart;
  late String presetNameText;
  late String growingPhaseText;
  late String holdInPhaseText;
  late String shrinkingPhaseText;
  late String holdOutPhaseText;
  late int growingPhaseDurationInSeconds;
  late int holdInPhaseDurationInSeconds;
  late int shrinkingPhaseDurationInSeconds;
  late int holdOutPhaseDurationInSeconds;
  late String? key;

  late PlayBreathingData current;
  // isInitialized ist false, wenn ein neues Cubit erstellt wird
  // und ist true, wenn initData() aufgerufen wurde
  bool isInitialized = false;

  // initialisiert die Daten
  void initData() {
    showTexts = false;
    showCount = false;
    skipHolds = false;
    isFavorite = false;
    isStart = false;
    presetNameText = "";
    growingPhaseText = "";
    holdInPhaseText = "";
    shrinkingPhaseText = "";
    holdOutPhaseText = "";
    growingPhaseDurationInSeconds = 1;
    holdInPhaseDurationInSeconds = 1;
    shrinkingPhaseDurationInSeconds = 1;
    holdOutPhaseDurationInSeconds = 1;
    key = null;
    isInitialized = true;
  }

  // gibt die aktuelle Daten aus
  PlayBreathingData getCurrentData() {
    if (!isInitialized) {
      initData();
    }
    return PlayBreathingData(
      showTexts: showTexts,
      showCount: showCount,
      skipHolds: skipHolds,
      isFavorite: isFavorite,
      isStart: isStart,
      presetNameText: presetNameText,
      growingPhaseText: growingPhaseText,
      holdInPhaseText: holdInPhaseText,
      shrinkingPhaseText: shrinkingPhaseText,
      holdOutPhaseText: holdOutPhaseText,
      growingPhaseDurationInSeconds: growingPhaseDurationInSeconds,
      holdInPhaseDurationInSeconds: holdInPhaseDurationInSeconds,
      shrinkingPhaseDurationInSeconds: shrinkingPhaseDurationInSeconds,
      holdOutPhaseDurationInSeconds: holdOutPhaseDurationInSeconds,
      key: key,
    );
  }

  // liest die Daten aus dem Preset und speichert sie im State
  // und in einem PlayBreathingData Objekt
  void setDataFromPreset({required Preset preset}) {
    var current = getCurrentData();
    growingPhaseDurationInSeconds = preset.durationsInSeconds != null &&
            preset.durationsInSeconds?[CirclePhase.growing] != null
        ? preset.durationsInSeconds![CirclePhase.growing]!.toInt()
        : 1;
    holdInPhaseDurationInSeconds = preset.durationsInSeconds != null &&
            preset.durationsInSeconds?[CirclePhase.holdIn] != null
        ? preset.durationsInSeconds![CirclePhase.holdIn]!.toInt()
        : 1;
    shrinkingPhaseDurationInSeconds = preset.durationsInSeconds != null &&
            preset.durationsInSeconds?[CirclePhase.shrinking] != null
        ? preset.durationsInSeconds![CirclePhase.shrinking]!.toInt()
        : 1;
    holdOutPhaseDurationInSeconds = preset.durationsInSeconds != null &&
            preset.durationsInSeconds?[CirclePhase.holdOut] != null
        ? preset.durationsInSeconds![CirclePhase.holdOut]!.toInt()
        : 1;
    growingPhaseText =
        preset.texts != null && preset.texts?[CirclePhase.growing] != null
            ? preset.texts![CirclePhase.growing].toString()
            : "";
    holdInPhaseText =
        preset.texts != null && preset.texts?[CirclePhase.growing] != null
            ? preset.texts![CirclePhase.holdIn].toString()
            : "";
    shrinkingPhaseText =
        preset.texts != null && preset.texts?[CirclePhase.growing] != null
            ? preset.texts![CirclePhase.shrinking].toString()
            : "";
    holdOutPhaseText =
        preset.texts != null && preset.texts?[CirclePhase.growing] != null
            ? preset.texts![CirclePhase.holdOut].toString()
            : "";
    showTexts = preset.showTexts;
    showCount = preset.showCount;
    skipHolds = preset.skipHolds;
    isFavorite = preset.isFavorite;
    isStart = preset.isStart;
    presetNameText = preset.name;
    key = preset.key;
    current.growingPhaseDurationInSeconds = growingPhaseDurationInSeconds;
    current.holdInPhaseDurationInSeconds = holdInPhaseDurationInSeconds;
    current.shrinkingPhaseDurationInSeconds = shrinkingPhaseDurationInSeconds;
    current.holdOutPhaseDurationInSeconds = holdOutPhaseDurationInSeconds;
    current.growingPhaseText = growingPhaseText;
    current.holdInPhaseText = holdInPhaseText;
    current.shrinkingPhaseText = shrinkingPhaseText;
    current.holdOutPhaseText = holdOutPhaseText;
    current.showTexts = showTexts;
    current.showCount = showCount;
    current.skipHolds = skipHolds;
    current.isFavorite = isFavorite;
    current.isStart = isStart;
    current.presetNameText = presetNameText;
    current.key = key;
    emit(current);
  }
}
