import 'package:flutter/material.dart';
import 'package:simple_crud_n_print/screens/data/employee_screen.dart';
import 'package:simple_crud_n_print/screens/data/position_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int _tabIndex = 0;

  final List<Tab> _tabs = [
    const Tab(
      icon: Icon(Icons.account_circle),
      text: 'Employees',
    ),
    const Tab(
      icon: Icon(Icons.hive_sharp),
      text: 'Positions',
    )
  ];

  final List<Widget> _tabBarViews = [
    const EmployeeScreen(),
    const PositionScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (_tabBarViews[_tabIndex] is PositionScreen) {
                    const PositionScreen().form(context: context);
                  }
                },
                child: const Icon(Icons.add)),
            appBar: AppBar(
              title: const Text('Data'),
              bottom: TabBar(
                  onTap: (int index) {
                    _tabIndex = index;
                  },
                  tabs: _tabs),
            ),
            body: TabBarView(children: _tabBarViews),
          )),
    );
  }
}
