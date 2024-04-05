// Datentransfer Klasse für den PlayBreathingScreen
// wird vom BlocBuilder verwendet, und dient als Übergabe-Klasse
// von Daten aus dem PlayBreathingCubit an die PlayBreathingScreen

// Ähnlichkeiten zur PlayBreathingData sind beabsichtigt :-P

// Aktuell sind es zwei unterschiedliche Klassen, damit ich an
// der PlayBreathingData arbeiten kann, ohne dass ich darauf
// achten muss, ob es bei der EditBreathingData Probleme macht.

// Falls es nicht zu Problemen kommt, und beide Klassen so ähnlich
// bleiben wie jetzt, macht es vielleicht Sinn, beide Klassen
// zusammen zu führen. (Nach der Projektwoche)

class PlayBreathingData {
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

  PlayBreathingData(
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
