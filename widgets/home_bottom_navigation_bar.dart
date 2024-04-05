// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:breathe/pages/edit_breathing_page.dart';
import 'package:breathe/pages/preset_list_page.dart';
import 'package:breathe/screens/home.dart';
import 'package:breathe/screens/meditation_timer_screen.dart';
import 'package:breathe/screens/retention_screen.dart';
import 'package:flutter/material.dart';

class HomeButtonNavigationBar extends StatefulWidget {
  const HomeButtonNavigationBar({super.key});

  @override
  State<HomeButtonNavigationBar> createState() =>
      _HomeButtonNavigationBarState();
}

class _HomeButtonNavigationBarState extends State<HomeButtonNavigationBar> {
// Liste der Seiten, auf die von der Bottom Navigation Bar
// aus hin navigiert wird
  final List _navSeiten = [
    HomeScreen(),
    EditBreathingPage(),
    StartRetentionScreen(),
    MeditationTimerScreen(),
    PresetListPage(),
  ];

// Navigiert bei einem Klick auf die Bottom Navigation Bar
// zur Seite vom Index
  void _onItemTapped(int index) {
    // Index 0 ist Home. Und da die ButtonNavigationBar nur
    // in Home gezeigt wird, ist eine Navigation zu Home
    // nicht notwendig
    if (index == 0) {
      return;
    }

    // Navigiert zu der NavSeite mit dem Index aus dem Parameter
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _navSeiten[index],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // damit die Labels auch gezeigt werden, wenn
      // das Item nicht ausgewählt ist
      showUnselectedLabels: true,
      // um den Abstand zwischen den Items gleichmäßig
      // zu halten. Bei vier oder mehr ist shifting
      // default.
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(index),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.air),
          label: 'Breathing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_outlined),
          label: 'Retention',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.spa_outlined),
          label: 'Meditation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_rounded),
          label: 'Favorites',
        ),
      ],
    );
  }
}
