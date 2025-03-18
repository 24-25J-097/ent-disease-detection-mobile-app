import 'package:flutter/material.dart';
import 'foreign-detection.dart';
import 'foreign_reports.dart';

class ForeignHomeScreen extends StatefulWidget {
  const ForeignHomeScreen({Key? key}) : super(key: key);

  @override
  State<ForeignHomeScreen> createState() => _ForeignHomeScreenState();
}

class _ForeignHomeScreenState extends State<ForeignHomeScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _pages = [
    CreateForeignBodiesReport(),
    ForeignReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'New Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}