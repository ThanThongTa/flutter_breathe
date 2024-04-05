// ignore_for_file: prefer_const_constructors

import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:flutter/material.dart';

//* die Klasse ist hier für die Navigation, und nicht im Scope für das Projekt *//
class MeditationListScreen extends StatefulWidget {
  const MeditationListScreen({super.key});

  @override
  State<MeditationListScreen> createState() => _MeditationListScreenState();
}

class _MeditationListScreenState extends State<MeditationListScreen>
    with StyledAppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Meditation List'),
      body: Center(
        child: Text('Hello World from Meditation List!'),
      ),
    );
  }
}
