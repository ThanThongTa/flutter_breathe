// ignore_for_file: prefer_const_constructors

import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:flutter/material.dart';

//^ die Klasse ist hier für die Navigation, und nicht im Scope für das Projekt
class MeditationTimerScreen extends StatefulWidget {
  const MeditationTimerScreen({super.key});

  @override
  State<MeditationTimerScreen> createState() => _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends State<MeditationTimerScreen>
    with StyledAppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Meditation Timer'),
      body: Center(
        child: Text('Hello World from Meditation Timer!'),
      ),
    );
  }
}
