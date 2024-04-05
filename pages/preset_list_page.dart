import 'package:breathe/cubits/preset_list_cubit.dart';
import 'package:breathe/screens/preset_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// PresetListPage dient als BlocProvider für den PresetListScreen
class PresetListPage extends StatelessWidget {
  const PresetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PresetListCubit(),
      child: const PresetListScreen(),
    );
  }
}
