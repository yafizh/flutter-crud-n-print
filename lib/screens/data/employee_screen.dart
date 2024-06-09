import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/models/employee.dart';
import 'package:simple_crud_n_print/models/position.dart';
import 'package:simple_crud_n_print/services/employee_service.dart';
import 'package:simple_crud_n_print/services/position_service.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  void form({context, Employee? employee}) async {
    String? name = employee?.name;
    int? positionId = employee?.positionId;

    List<Position> _positions =
        await Provider.of<PositionService>(context, listen: false)
            .getPositions();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Form(
                child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(
                      labelText: 'Employee Name', border: OutlineInputBorder()),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                    value: positionId,
                    decoration: const InputDecoration(
                        labelText: 'Employee Position',
                        border: OutlineInputBorder()),
                    items: _positions
                        .map(
                          (position) => DropdownMenuItem(
                              value: position.id, child: Text(position.name)),
                        )
                        .toList(),
                    onChanged: (value) {
                      positionId = value;
                    }),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.grey)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              if (employee == null) {
                                Provider.of<EmployeeService>(context,
                                        listen: false)
                                    .insertEmployee(Employee(
                                        name: name!, positionId: positionId!));
                              } else {
                                Provider.of<EmployeeService>(context,
                                        listen: false)
                                    .updateEmployee(Employee(
                                        id: employee.id,
                                        name: name!,
                                        positionId: positionId!));
                              }
                              Navigator.pop(context);
                            },
                            child: Text(employee == null
                                ? 'Add Employee'
                                : 'Edit Employee')))
                  ],
                )
              ],
            )),
          );
        });
  }

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
                          IconButton(
                            onPressed: () async {
                              const EmployeeScreen().form(
                                  context: context,
                                  employee: snapshot.data![index]);
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.yellow,
                          ),
                          IconButton(
                            onPressed: () async {
                              Provider.of<EmployeeService>(context,
                                      listen: false)
                                  .deleteEmployee(snapshot.data![index].id!);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  );
                });
          });
    });
  }
}
