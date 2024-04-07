import 'package:breathe/cubits/edit_breathing_cubit.dart';
import 'package:breathe/cubits/play_breathing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ein paar Extensions für den BuildContext, damit ich den Code
// einfacher lesen kann
extension ContextExtensions on BuildContext {
  EditBreathingCubit get editBreathingCubit => read<EditBreathingCubit>();
  PlayBreathingCubit get playBreathingCubit => read<PlayBreathingCubit>();
  void showSnackBar(SnackBar snackBar) =>
      ScaffoldMessenger.of(this).showSnackBar(snackBar);
}
