import 'package:flutter/material.dart';
import 'package:simple_crud_n_print/models/employee.dart';
import 'package:simple_crud_n_print/models/position.dart';
import 'package:simple_crud_n_print/services/database_service.dart';
import 'package:simple_crud_n_print/services/position_service.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeService extends ChangeNotifier {
  final tableName = 'employees';

  Future<void> createTable(Database database) async {
    return database.execute("""
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          position_id INTEGER, 
          name VARCHAR(255)
        )
      """);
  }

  Future<int> insertEmployee(Employee employee) async {
    final db = await DatabaseService().database;
    final result = await db.insert(tableName, employee.toMap());

    notifyListeners();

    return result;
  }

  Future<List<Employee>> employees({bool withPosition = false}) async {
    final db = await DatabaseService().database;

    if (withPosition) {
      final List<Map<String, Object?>> employeeMaps = await db.rawQuery("""
        SELECT 
          $tableName.id,
          $tableName.position_id,
          $tableName.name,
          ${PositionService().tableName}.name AS position_name 
        FROM $tableName 
        INNER JOIN ${PositionService().tableName} ON ${PositionService().tableName}.id = $tableName.position_id 
      """);

      print(employeeMaps);

      return [
        for (final {
              'id': id as int,
              'position_id': positionId as int,
              'name': name as String,
              'position_name': positionName as String
            } in employeeMaps)
          Employee(
              id: id,
              positionId: positionId,
              name: name,
              posotion: Position(id: positionId, name: positionName)),
      ];
    } else {
      final List<Map<String, Object?>> employeeMaps = await db.query(tableName);

      return [
        for (final {
              'id': id as int,
              'position_id': positionId as int,
              'name': name as String,
            } in employeeMaps)
          Employee(id: id, positionId: positionId, name: name),
      ];
    }
  }

  Future<int> updateEmployee(Employee employee) async {
    final db = await DatabaseService().database;
    final result = await db.update(
      tableName,
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );

    notifyListeners();

    return result;
  }

  Future<int> deleteEmployee(int id) async {
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
