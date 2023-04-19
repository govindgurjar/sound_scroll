import 'package:sound_scrolls/pages/home/tabs/radio_tab.dart';
import 'package:flutter/material.dart';

import 'tabs/news_tab.dart';
import 'tabs/podcast_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// This widget is the root of your application.
  int _selectedIndex = 0;

  _onItemTapped(iteamIndex) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C293A),
      body: _selectedIndex == 0
          ? RadioTab()
          : _selectedIndex == 1
              ? NewsTab()
              : PodCastTab(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.radio_rounded),
            label: 'Radio',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_rounded),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.podcasts_rounded),
            label: 'Podcast',
          ),
        ],
      ),
    );
  }
}
