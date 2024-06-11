import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:simple_crud_n_print/screens/report/employee_screen.dart';
import 'package:simple_crud_n_print/screens/report/position_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      if (_tabBarViews[_tabIndex] is EmployeeScreen) {
                        return PdfPreview(
                            build: (format) => const EmployeeScreen()
                                .generatePdf(context, format));
                      } else if (_tabBarViews[_tabIndex] is PositionScreen) {
                        return PdfPreview(
                            build: (format) => const PositionScreen()
                                .generatePdf(context, format));
                      }

                      return const Center(
                        child: Text('PDF NOT FOUND'),
                      );
                    },
                  );
                },
                child: const Icon(Icons.print)),
            appBar: AppBar(
              title: const Text('Report'),
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
