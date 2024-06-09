import 'package:simple_crud_n_print/models/position.dart';

class Employee {
  final int? id;
  final int positionId;
  final String name;
  final Position? posotion;

  Employee(
      {this.id, required this.name, required this.positionId, this.posotion});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'position_id': positionId,
      'name': name,
    };
  }
}
