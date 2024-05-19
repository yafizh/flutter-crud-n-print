import 'package:flutter/material.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
                onPressed: () {}, child: const Icon(Icons.add)),
            appBar: AppBar(
              title: const Text('Data'),
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.account_circle),
                  text: 'Employees',
                ),
                Tab(
                  icon: Icon(Icons.add_ic_call),
                  text: 'Phone Numbers',
                ),
              ]),
            ),
            body: const TabBarView(children: [
              Icon(Icons.account_circle),
              Icon(Icons.add_ic_call),
            ]),
          )),
    );
  }
}
