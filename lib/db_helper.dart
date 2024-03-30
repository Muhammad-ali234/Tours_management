import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:toursapp/model.dart'; // Import your Tour model

class DatabaseHelper {
  final databaseName = "alkhanTours.db";

  String tourDatatTbl = '''
CREATE TABLE tours (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ticket TEXT NOT NULL,
  sector TEXT NOT NULL,
  date TEXT NOT NULL,
  name TEXT NOT NULL,
  reference TEXT, 
  invoiceAmount REAL,
  netAmount REAL,
  margin REAL
)''';

  Future<Database> init() async {
    sqfliteFfiInit(); // Initialize sqflite FFI
    databaseFactory = databaseFactoryFfi; // Initialize databaseFactory

    final databasePath = await getApplicationDocumentsDirectory();
    final path = join(databasePath.path, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(tourDatatTbl);
    });
  }

  Future<int> insertTour(Tour tour) async {
    final Database db = await init();
    return db.insert("tours", tour.toMap());
  }

  Future<List<Tour>> getTours() async {
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('tours');
    return List.generate(maps.length, (i) {
      return Tour(
        id: maps[i]['id'],
        ticket: maps[i]['ticket'],
        sector: maps[i]['sector'],
        date: maps[i]['date'],
        name: maps[i]['name'],
        reference: maps[i]['reference'], // Include reference field
        invoiceAmount: maps[i]['invoiceAmount'],
        netAmount: maps[i]['netAmount'],
        margin: maps[i]['margin'],
      );
    });
  }

  Future<void> updateTour(Tour editedTour) async {
    final Database db = await init();
    await db.update(
      'tours',
      editedTour.toMap(),
      where: 'id = ?',
      whereArgs: [editedTour.id],
    );
  }

  Future<int> deleteTour(int id) async {
    final Database db = await init();
    return db.delete(
      'tours',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
