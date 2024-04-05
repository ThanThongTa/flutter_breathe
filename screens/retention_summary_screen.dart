// ignore_for_file: prefer_const_constructors

import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:flutter/material.dart';

// die Klasse ist hier für die Navigation, und nicht im Scope für das Projekt
class RetentionSummaryScreen extends StatefulWidget {
  const RetentionSummaryScreen({super.key});

  @override
  State<RetentionSummaryScreen> createState() => _RetentionSummaryScreenState();
}

class _RetentionSummaryScreenState extends State<RetentionSummaryScreen>
    with StyledAppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Summary'),
      body: Center(
        child: Text('Hello World from Summary Screen!'),
      ),
    );
  }
}
