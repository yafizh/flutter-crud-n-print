import 'package:path/path.dart';
import 'package:simple_crud_n_print/services/employee_service.dart';
import 'package:simple_crud_n_print/services/position_service.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initialize();

    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'simple_crud_n_print.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path, version: 2, onCreate: create,
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion == 1) {
        await EmployeeService().createTable(db);
      }
    });

    return database;
  }

  Future<void> create(Database database, int version) async {
    await PositionService().createTable(database);
    await EmployeeService().createTable(database);
  }
}
