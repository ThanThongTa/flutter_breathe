import 'package:hive_flutter/hive_flutter.dart';

part 'circle_phase.g.dart';

// Enums der einzelnen Phasen einer Kreis Animation
@HiveType(typeId: 2)
enum CirclePhase {
  @HiveField(0)
  growing, // wachsender Kreis, einatmen
  @HiveField(1)
  holdIn, // Kreis bleibt groß, wie er ist, Luft anhalten
  @HiveField(2)
  shrinking, // schrumpfender Kreis, ausatment
  @HiveField(3)
  holdOut, // Kreis bleibt klein, wie er ist, Luft anhalten
}
