import 'package:breathe/cubits/edit_breathing_cubit.dart';
import 'package:breathe/screens/edit_breathing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// EditBreathingPage dient als BlocProvider für die EditBreathingScreen
// wird benötigt, damit der EditBreathingScreen einen BlocBuilder verwenden kann,
// und der BlocBuilder nicht denselben Context hat wie der BlocProvider
// verbindet auch den EditBreathingCubit mit dem EditBreathingScreen
class EditBreathingPage extends StatelessWidget {
  const EditBreathingPage({super.key, this.presetKey});
  final String? presetKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditBreathingCubit(),
      child: EditBreathingScreen(
        presetKey: presetKey,
      ),
    );
  }
}
