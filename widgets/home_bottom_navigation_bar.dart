// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:breathe/pages/edit_breathing_page.dart';
import 'package:breathe/pages/preset_list_page.dart';
import 'package:breathe/screens/home.dart';
import 'package:breathe/screens/meditation_timer_screen.dart';
import 'package:breathe/screens/retention_screen.dart';
import 'package:flutter/material.dart';

//TODO: Use a navigation rail for wide screen / landscape
//TODO: Use MediaQuery to check if screen is wide / landscape

// Widget für die BottomNavigationBar im HomeScreen
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _navSeiten[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) => _onItemTapped(index),
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.air),
          label: 'Breathing',
        ),
        NavigationDestination(
          icon: Icon(Icons.timer_outlined),
          label: 'Retention',
        ),
        NavigationDestination(
          icon: Icon(Icons.spa_outlined),
          label: 'Meditation',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          label: 'Favorites',
        ),
      ],
    );
  }
}
