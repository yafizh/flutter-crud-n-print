import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/screens/home.dart';
import 'package:simple_crud_n_print/services/employee_service.dart';
import 'package:simple_crud_n_print/services/position_service.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PositionService()),
      ChangeNotifierProvider(create: (context) => EmployeeService())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: const Home(),
    );
  }
}
