import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:kesehatan_ku/views/halaman/deskop.dart';
import 'package:kesehatan_ku/views/halaman/healtyhalaman1.dart';
import 'package:kesehatan_ku/views/halaman/profile/utils/screen/profile_screen.dart';
import 'package:kesehatan_ku/views/halaman/scaninghalaman2.dart';
import 'package:kesehatan_ku/views/halaman/settinghalaman4.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    // Center(child: Text("Home")),
    deskop(),
    healty(),
    scaning(),
    ProfileScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFF1FB2A5),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.monitor_heart_outlined),
            label: 'health',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.qr_code_2_rounded),
            label: 'scan',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.perm_identity),
            label: 'Personal',
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _widgetOptions[_selectedIndex],
    );
  }
}
