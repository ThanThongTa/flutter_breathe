import 'package:breathe/cubits/play_breathing_cubit.dart';
import 'package:breathe/screens/play_breathing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// PlayBreathingPage dient als BlocProvider für den PlayBreathingScreen
class PlayBreathingPage extends StatelessWidget {
  const PlayBreathingPage({super.key, this.presetKey});
  final String? presetKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayBreathingCubit(),
      child: PlayBreathingScreen(
        presetKey: presetKey,
      ),
    );
  }
}
