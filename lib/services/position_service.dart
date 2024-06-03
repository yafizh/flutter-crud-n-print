import 'package:flutter/material.dart';
import 'package:simple_crud_n_print/models/position.dart';
import 'package:simple_crud_n_print/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class PositionService extends ChangeNotifier {
  final tableName = 'positions';

  Future<void> createTable(Database database) async {
    return database.execute("""
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name VARCHAR(255)
        )
      """);
  }

  Future<int> insertPosition(Position position) async {
    final db = await DatabaseService().database;
    final result = await db.insert(tableName, position.toMap());

    notifyListeners();

    return result;
  }

  Future<List<Position>> getPositions() async {
    final db = await DatabaseService().database;

    final List<Map<String, Object?>> positionMaps = await db.query(tableName);

    return [
      for (final {
            'id': id as int,
            'name': name as String,
          } in positionMaps)
        Position(id: id, name: name),
    ];
  }

  Future<int> updatePosition(Position position) async {
    final db = await DatabaseService().database;
    final result = await db.update(
      tableName,
      position.toMap(),
      where: 'id = ?',
      whereArgs: [position.id],
    );

    notifyListeners();

    return result;
  }

  Future<int> deletePosition(int id) async {
    final db = await DatabaseService().database;
    final result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    notifyListeners();

    return result;
  }
}
