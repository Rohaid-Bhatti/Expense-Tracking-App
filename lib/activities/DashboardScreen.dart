import 'package:demo/fragments/ExpenseListFragment.dart';
import 'package:demo/fragments/ExpenseUploadFragment.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        // indicatorColor: Colors.greenAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.manage_history),
            icon: Icon(Icons.manage_history_outlined),
            label: 'History',
          ),
        ],
      ),
      body: <Widget>[
        ExpenseUploadFragment(),
        ExpenseListFragment(),
      ][currentPageIndex],
    );
  }
}
