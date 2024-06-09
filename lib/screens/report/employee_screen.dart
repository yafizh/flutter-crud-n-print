import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/services/employee_service.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeService>(builder: (context, value, child) {
      return FutureBuilder(
          future: value.employees(withPosition: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Server Error'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Employee is Empty'));
            }

            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data![index].name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(snapshot.data![index].posotion!.name)
                            ],
                          )),
                        ],
                      ),
                    ),
                  );
                });
          });
    });
  }
}
