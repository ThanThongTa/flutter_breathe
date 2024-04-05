// ignore_for_file: prefer_const_constructors

import 'package:breathe/mixins/styled_app_bar_mixin.dart';
import 'package:flutter/material.dart';

//! die Klasse ist hier für die Navigation, und nicht im Scope für das Projekt
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with StyledAppBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getStyledAppBar(context, title: 'Favorites'),
      body: Center(
        child: Text('Hello World from Favorites Screen'),
      ),
    );
  }
}
