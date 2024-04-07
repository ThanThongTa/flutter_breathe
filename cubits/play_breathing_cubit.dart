import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/viewmodels/play_breathing_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Möglicherweise gibt es ein Reflection / Mapping Tool, dass hier leicht anzuwenden ist

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

    var durationsLocal = preset.durationsInSeconds;
    if (durationsLocal is Map<CirclePhase, double>) {
      var growingLocal = durationsLocal[CirclePhase.growing];
      var holdInLocal = durationsLocal[CirclePhase.holdIn];
      var shrinkingLocal = durationsLocal[CirclePhase.shrinking];
      var holdOutLocal = durationsLocal[CirclePhase.holdOut];

      growingPhaseDurationInSeconds =
          growingLocal is double ? growingLocal.toInt() : 1;
      holdInPhaseDurationInSeconds =
          holdInLocal is double ? holdInLocal.toInt() : 1;
      shrinkingPhaseDurationInSeconds =
          shrinkingLocal is double ? shrinkingLocal.toInt() : 1;
      holdOutPhaseDurationInSeconds =
          holdOutLocal is double ? holdOutLocal.toInt() : 1;
    } else {
      growingPhaseDurationInSeconds = 1;
      holdInPhaseDurationInSeconds = 1;
      shrinkingPhaseDurationInSeconds = 1;
      holdOutPhaseDurationInSeconds = 1;
    }

    var textsLocal = preset.texts;
    if (textsLocal is Map<CirclePhase, String>) {
      growingPhaseText = textsLocal[CirclePhase.growing]!;
      holdInPhaseText = textsLocal[CirclePhase.holdIn]!;
      shrinkingPhaseText = textsLocal[CirclePhase.shrinking]!;
      holdOutPhaseText = textsLocal[CirclePhase.holdOut]!;
    } else {
      growingPhaseText = "";
      holdInPhaseText = "";
      shrinkingPhaseText = "";
      holdOutPhaseText = "";
    }

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
