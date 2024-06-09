import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_crud_n_print/services/position_service.dart';

class PositionScreen extends StatelessWidget {
  const PositionScreen({super.key});

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
                        ],
                      ),
                    ),
                  );
                });
          });
    });
  }
}
