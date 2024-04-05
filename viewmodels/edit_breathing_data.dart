// Datentransfer Klasse für den EditBreathingScreen
// wird vom BlocBuilder verwendet, und dient als Übergabe-Klasse
// von Daten aus dem EditBreathingCubit an die EditBreathingScreen

class EditBreathingData {
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

  EditBreathingData(
      {this.showTexts = false,
      this.showCount = false,
      this.skipHolds = false,
      this.isFavorite = false,
      this.isStart = false,
      this.presetNameText = "",
      this.growingPhaseText = "",
      this.holdInPhaseText = "",
      this.shrinkingPhaseText = "",
      this.holdOutPhaseText = "",
      this.growingPhaseDurationInSeconds = 1,
      this.holdInPhaseDurationInSeconds = 1,
      this.shrinkingPhaseDurationInSeconds = 1,
      this.holdOutPhaseDurationInSeconds = 1,
      this.key});
}
