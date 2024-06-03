import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/models/position.dart';
import 'package:simple_crud_n_print/services/position_service.dart';

class PositionScreen extends StatefulWidget {
  const PositionScreen({super.key});

  static void form({context, Position? position}) {
    String? name = position?.name;

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
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Position Name', border: OutlineInputBorder()),
                  onChanged: (value) {
                    name = value;
                  },
                ),
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
                            onPressed: () {
                              if (position == null) {
                                Provider.of<PositionService>(context,
                                        listen: false)
                                    .insertPosition(Position(name: name!));
                              } else {
                                Provider.of<PositionService>(context,
                                        listen: false)
                                    .updatePosition(
                                        Position(id: position.id, name: name!));
                              }
                              Navigator.pop(context);
                            },
                            child: Text(position == null
                                ? 'Add Position'
                                : 'Edit Position')))
                  ],
                )
              ],
            )),
          );
        });
  }

  @override
  State<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PositionService>(builder: (context, value, child) {
      return FutureBuilder(
          future: value.getPositions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text('Loading...'));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Server Error'));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('Position is Empty'));
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
                          Expanded(child: Text(snapshot.data![index].name)),
                          IconButton(
                            onPressed: () async {
                              PositionScreen.form(
                                  context: context,
                                  position: snapshot.data![index]);
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.yellow,
                          ),
                          IconButton(
                            onPressed: () async {
                              Provider.of<PositionService>(context,
                                      listen: false)
                                  .deletePosition(snapshot.data![index].id!);
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
