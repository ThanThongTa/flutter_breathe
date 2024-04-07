import 'package:breathe/viewmodels/home_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit für die Business Logic des Homescreens
// da bisher keine wirklichen State Changes ausgelöst werden,
// ist diese Klasse erst mal leer. Vielleicht kommen später
// noch welche dazu.
class HomeCubit extends Cubit<HomeData> {
  HomeCubit() : super(HomeData());
}
