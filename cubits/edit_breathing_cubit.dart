import 'package:breathe/interfaces/presets_controller.dart';
import 'package:breathe/datamodels/circle_phase.dart';
import 'package:breathe/datamodels/preset.dart';
import 'package:breathe/viewmodels/edit_breathing_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit übernimmt die Geschäftslogik des EditBreathingScreens
// damit sich die Screen Klasse nur noch mit der Präsentation beschäftigen muss
class EditBreathingCubit extends Cubit<EditBreathingData> {
  EditBreathingCubit() : super(EditBreathingData());
  // Variablen für die eingegebenen Daten
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

  late EditBreathingData current;
  // isInitialized ist false, wenn ein neues Cubit erstellt wird
  // und ist true, wenn initData() aufgerufen wurde
  bool isInitialized = false;

  // initialisiert die Variablen mit Standardwerten
  // wird in der GetCurrentData Funktion aufgerufen, wenn
  // isInitialized false ist und setzt dies dann auf true,
  // damit die Variablen nur einmal initialisiert werden
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

  // erstellt aus den eingebenen Daten ein EditBreathingData
  // das wird dann zurück an die Präsentationsschicht / die Screen Klasse
  // geschickt
  EditBreathingData getCurrentData() {
    if (!isInitialized) {
      initData();
    }
    return EditBreathingData(
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

  // erstellt aus den eingebenen Daten ein Preset
  // dieses Preset wird dann im Controller gespeichert
  Preset getPresetFromCurrentData() {
    return Preset(
        durationsInSeconds: {
          CirclePhase.growing: growingPhaseDurationInSeconds.toDouble(),
          CirclePhase.holdIn: holdInPhaseDurationInSeconds.toDouble(),
          CirclePhase.shrinking: shrinkingPhaseDurationInSeconds.toDouble(),
          CirclePhase.holdOut: holdOutPhaseDurationInSeconds.toDouble(),
        },
        texts: {
          CirclePhase.growing: growingPhaseText,
          CirclePhase.holdIn: holdInPhaseText,
          CirclePhase.shrinking: shrinkingPhaseText,
          CirclePhase.holdOut: holdOutPhaseText,
        },
        skipHolds: skipHolds,
        showCount: showCount,
        showTexts: showTexts,
        isFavorite: isFavorite,
        isStart: isStart,
        name: presetNameText,
        key: key);
  }

  // Mapping von einem BreathingData zu einem Preset
  Preset getPresetFromBreathingData(
      {required EditBreathingData breathingData}) {
    return Preset(
        durationsInSeconds: {
          CirclePhase.growing:
              breathingData.growingPhaseDurationInSeconds.toDouble(),
          CirclePhase.holdIn:
              breathingData.holdInPhaseDurationInSeconds.toDouble(),
          CirclePhase.shrinking:
              breathingData.shrinkingPhaseDurationInSeconds.toDouble(),
          CirclePhase.holdOut:
              breathingData.holdOutPhaseDurationInSeconds.toDouble(),
        },
        texts: {
          CirclePhase.growing: breathingData.growingPhaseText,
          CirclePhase.holdIn: breathingData.holdInPhaseText,
          CirclePhase.shrinking: breathingData.shrinkingPhaseText,
          CirclePhase.holdOut: breathingData.holdOutPhaseText,
        },
        skipHolds: breathingData.skipHolds,
        showCount: breathingData.showCount,
        showTexts: breathingData.showTexts,
        isFavorite: breathingData.isFavorite,
        isStart: breathingData.isStart,
        name: breathingData.presetNameText,
        key: breathingData.key);
  }

  // entfernt den UniqueKey und ermöglicht es so, dass ein Preset
  // als neues Preset gespeichert wird
  void removeUniqueKey() {
    current = getCurrentData();
    key = null;
    current.key = null;
    emit(current);
  }

  // setzt den UniqueKey
  void setUniqueKey(String value) {
    current = getCurrentData();
    key = value;
    current.key = value;
    emit(current);
  }

  // ändert den Wert von showTexts hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void toggleShowTexts(value) {
    current = getCurrentData();
    showTexts = value;
    current.showTexts = value;
    emit(current);
  }

  // ändert den Wert von showCounts hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void toggleShowCount(value) {
    var current = getCurrentData();
    showCount = value;
    current.showCount = value;
    emit(current);
  }

// ändert den Wert von skipHolds hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void toggleSkipHolds(value) {
    var current = getCurrentData();
    skipHolds = value;
    current.skipHolds = value;
    emit(current);
  }

// ändert den Wert von isFavorite hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void toggleIsFavorite(value) {
    var current = getCurrentData();
    isFavorite = value;
    current.isFavorite = value;
    emit(current);
  }

  // ändert den Wert von isStart hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void toggleIsStart(value) {
    var current = getCurrentData();
    isStart = value;
    current.isStart = value;
    emit(current);
  }

  // ändert den Wert von PresetNameText hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setPresetNameText(String value) {
    var current = getCurrentData();
    presetNameText = value;
    current.presetNameText = value;
    emit(current);
  }

  // ändert den Wert von GrowingPhaseText hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setGrowingPhaseText(String value) {
    var current = getCurrentData();
    growingPhaseText = value;
    current.growingPhaseText = value;
    emit(current);
  }

  // Ändert den Wert von HoldInPhaseText hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setHoldInPhaseText(String value) {
    var current = getCurrentData();
    holdInPhaseText = value;
    current.holdInPhaseText = value;
    emit(current);
  }

  // Ändert den Wert von ShrinkingPhaseText hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setShrinkingPhaseText(value) {
    var current = getCurrentData();
    shrinkingPhaseText = value;
    current.shrinkingPhaseText = value;
    emit(current);
  }

  // Ändert den Wert von HoldOutPhaseText hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setHoldOutPhaseText(String value) {
    var current = getCurrentData();
    holdOutPhaseText = value;
    current.holdOutPhaseText = value;
    emit(current);
  }

  // Ändert den Wert von GrowingPhaseDurationInSeconds hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setGrowingPhaseDurationInSeconds(int value) {
    var current = getCurrentData();
    growingPhaseDurationInSeconds = value;
    current.growingPhaseDurationInSeconds = value;
    emit(current);
  }

  // Ändert den Wert von HoldInPhaseDurationInSeconds hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setHoldInPhaseDurationInSeconds(int value) {
    var current = getCurrentData();
    holdInPhaseDurationInSeconds = value;
    current.holdInPhaseDurationInSeconds = value;
    emit(current);
  }

  // Ändert den Wert von ShrinkingPhaseDurationInSeconds hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setShrinkingPhaseDurationInSeconds(int value) {
    var current = getCurrentData();
    shrinkingPhaseDurationInSeconds = value;
    current.shrinkingPhaseDurationInSeconds = value;
    emit(current);
  }

  // Ändert den Wert von HoldOutPhaseDurationInSeconds hier in der Business Logic
  // und gibt dann ein EditBreathingData an die Screen Klasse
  // zurück
  void setHoldOutPhaseDurationInSeconds(int value) {
    var current = getCurrentData();
    holdOutPhaseDurationInSeconds = value;
    current.holdOutPhaseDurationInSeconds = value;
    emit(current);
  }

  // Kopiert die Daten aus einem Preset in ein EditBreathingData Objekt
  // und gibt dieses EditBreathingData Objekt zurück
  EditBreathingData getDataForPreset(Preset value) {
    return EditBreathingData(
        showTexts: value.showTexts,
        showCount: value.showCount,
        skipHolds: value.skipHolds,
        isFavorite: value.isFavorite,
        isStart: value.isStart,
        presetNameText: value.name,
        growingPhaseText: value.texts![CirclePhase.growing]!,
        holdInPhaseText: value.texts![CirclePhase.holdIn]!,
        shrinkingPhaseText: value.texts![CirclePhase.shrinking]!,
        holdOutPhaseText: value.texts![CirclePhase.holdOut]!,
        growingPhaseDurationInSeconds:
            value.durationsInSeconds![CirclePhase.growing]!.toInt(),
        holdInPhaseDurationInSeconds:
            value.durationsInSeconds![CirclePhase.holdIn]!.toInt(),
        shrinkingPhaseDurationInSeconds:
            value.durationsInSeconds![CirclePhase.shrinking]!.toInt(),
        holdOutPhaseDurationInSeconds:
            value.durationsInSeconds![CirclePhase.holdOut]!.toInt());
  }

  // Liest ein Preset ein und speichert alle seine Daten im State
  // und in einem EditBreathingData Objekt. Gibt dann das EditBreathingData
  // Objekt zurück
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

  // Speichert die aktuellen Daten in einem neuen Preset
  // in den animationPresets des angegebenen PresetControllers.
  // Aktualisiert dann die Hive Datenbank mit dem Controller.
  // Erstellt aus den aktuellen Daten dann ein EditBreathingData Objekt
  // und gibt dieses EditBreathingData Objekt an die Screen Klasse
  // zurück
  void saveNewPreset({required PresetsController controller}) {
    var current = getCurrentData();
    var currentPreset = getPresetFromBreathingData(breathingData: current);
    controller.animationPresets.add(currentPreset);

    // ruft die Update Funktion auf, um die Presets in die HiveBox zu speichern
    controller.updatePresetsInHive();
    controller.loadPresetsFromHive();

    emit(current);
  }

  // Falls ein Key vorhanden ist, wird geschaut, ob es auch ein Element
  // mit diesem Key in den Presets gibt. Falls ja, wird das Element aktualisiert.
  // Falls nicht, wird ein neues Preset erstellt
  void updateExistingPreset({required PresetsController controller}) {
    var current = getCurrentData();
    var updatedPreset = getPresetFromBreathingData(breathingData: current);
    var found =
        controller.animationPresets.any((element) => element.key == key);
    // falls es ein Preset mit dem angegebenen Key gibt
    if (found) {
      var foundPreset = controller.animationPresets.firstWhere(
        (element) => element.key == key,
      );
      var index = controller.animationPresets.indexOf(foundPreset);
      controller.animationPresets[index] = updatedPreset;

      controller.updatePresetsInHive();
      controller.loadPresetsFromHive();
      emit(current);
    } else {
      // falls nicht, erstelle ein neues Preset
      saveNewPreset(controller: controller);
    }
  }

  // Speichere das aktuelle Preset
  void savePreset({required PresetsController controller}) {
    if (key == null) {
      // key ist nur null, wenn das Preset neu ist
      saveNewPreset(controller: controller);
    } else {
      updateExistingPreset(controller: controller);
    }
  }
}
