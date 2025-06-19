import 'package:flutter/material.dart';
import 'pages/io_test_page.dart';
import 'pages/animation_page.dart';
import 'pages/list_page.dart';
import 'pages/chart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static List<String> titleList = ['Multithreaded IO Performance Test','Animation Performance Test','List Performance Test', 'Chart Performance Test'];
  String title = titleList[0];

  final List<Widget> _pages = const [
    IOTestPage(),
    AnimationPage(),
    ListPage(),
    ChartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
              title = titleList[index];
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'IO'),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Animation'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Chart'),
        ],
      ),
    );
  }
}
