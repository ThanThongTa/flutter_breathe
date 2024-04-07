// ignore_for_file: prefer_const_constructors

import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:flutter/material.dart';

//~ Tilde ist Alt/Option + N
//~ die Klasse ist hier für die Navigation, und nicht im Scope für das Projekt
class StartRetentionScreen extends StatefulWidget {
  const StartRetentionScreen({super.key});

  @override
  State<StartRetentionScreen> createState() => _StartRetentionScreenState();
}

class _StartRetentionScreenState extends State<StartRetentionScreen>
    with StyledAppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Retention'),
      body: Center(
        child: Text('Hello Start Retention World!'),
      ),
    );
  }
}
