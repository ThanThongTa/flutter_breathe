import 'package:breathe/datamodels/preset.dart';

// Datentransfer Klasse für den HomeScreen
class HomeData {
  // TODO: Ist das Starting Preset tatsächlich nullable?
  late Preset? startingPreset;

  HomeData({this.startingPreset});
}
