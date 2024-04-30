import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:toursapp/model.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class DatabaseHelper {
  final String databaseName = "test20.db";
  late Database _database;

  String tourDataTable = '''
CREATE TABLE tours (
  id TEXT PRIMARY KEY,
  ticket TEXT NOT NULL,
  sector TEXT NOT NULL,
  date TEXT NOT NULL,
  name TEXT NOT NULL,
  reference TEXT, 
  invoiceAmount REAL,
  netAmount REAL,
  margin REAL,
  flagMonthYear TEXT NOT NULL
)''';

  Future<Database> init() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(tourDataTable);
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
      return Tour.fromMap(maps[i]);
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

  Future<int> deleteTour(String? id) async {
    if (id == null) {
      throw ArgumentError('id cannot be null');
    }
    final Database db = await init();
    return await db.delete(
      'tours',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Tour>> getToursForMonth(String monthYear) async {
    final Database db = await init();

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM tours WHERE flagMonthYear = '$monthYear'");

    return List.generate(maps.length, (i) {
      return Tour(
        id: maps[i]['id'],
        ticket: maps[i]['ticket'],
        sector: maps[i]['sector'],
        date: maps[i]['date'],
        name: maps[i]['name'],
        reference: maps[i]['reference'],
        invoiceAmount: maps[i]['invoiceAmount'],
        netAmount: maps[i]['netAmount'],
        margin: maps[i]['margin'],
        flagMonthYear: maps[i]['flagMonthYear'],
      );
    });
  }

  Future<File> generatePDFForMonth(String monthYear) async {
    final List<Tour> tours = await getToursForMonth(monthYear);

    final pdf = pw.Document();

    // Initialize variables for totals
    int totalCustomers = tours.length;
    double totalInvoiceAmount = 0;
    double totalNetAmount = 0;
    double totalMargin = 0;

    // Calculate totals
    for (var tour in tours) {
      totalInvoiceAmount += tour.invoiceAmount;
      totalNetAmount += tour.netAmount;
      totalMargin += tour.margin;
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                  height: 60,
                  width: double.infinity,
                  child: pw.Center(
                    child: pw.Text('Monthly Sheet',
                        style: pw.TextStyle(
                            fontSize: 40,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue)),
                  )),
              pw.Header(
                level: 0,
                child: pw.Text('Wardet ALKhan LLC Branch 1 ($monthYear)'),
              ),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Date',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description',
                            style: const pw.TextStyle(color: PdfColors.blue)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Invoice amount',
                            style: const pw.TextStyle(color: PdfColors.green)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Net Amount',
                            style: const pw.TextStyle(color: PdfColors.orange)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Margin',
                            style: const pw.TextStyle(color: PdfColors.red)),
                      ),
                    ],
                  ),
                  for (var tour in tours)
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.white),
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tour.date),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tour.name),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tour.invoiceAmount.toString()),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tour.netAmount.toString()),
                        ),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tour.margin.toString()),
                        ),
                      ],
                    ),
                ],
              ),
              // Add total customers, total invoice amount, total net amount, and total margin separately
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Total Customers: $totalCustomers'),
                    pw.Text('Total Invoice Amount: $totalInvoiceAmount'),
                    pw.Text('Total Net Amount: $totalNetAmount'),
                    pw.Text('Total Margin: $totalMargin'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/tours_$monthYear.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateExcelForMonth(String monthYear) async {
    final List<Tour> tours = await getToursForMonth(monthYear);

    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

// Merge cells and set text alignment to center
    sheet.mergeCells;
    sheet.getRangeByIndex(1, 1).setText('Monthly Sheet');
    sheet.getRangeByIndex(1, 1).cellStyle.hAlign = xlsio.HAlignType.center;

// Increase font size
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize =
        20; // Adjust the font size as needed

// Set the headers for Date, Description, Invoice amount, Net Amount, and Margin
    sheet.getRangeByIndex(2, 1).setText('Date');
    sheet.getRangeByIndex(2, 2).setText('Description');
    sheet.getRangeByIndex(2, 3).setText('Invoice amount');
    sheet.getRangeByIndex(2, 4).setText('Net Amount');
    sheet.getRangeByIndex(2, 5).setText('Margin');

    // Write tour data
    for (int i = 0; i < tours.length; i++) {
      final Tour tour = tours[i];
      // Start writing data from row 3 onwards
      int rowIndex = i + 3;
      sheet.getRangeByName('A$rowIndex').setText(tour.date);
      sheet.getRangeByName('B$rowIndex').setText(tour.name);
      sheet.getRangeByName('C$rowIndex').setText(tour.invoiceAmount.toString());
      sheet.getRangeByName('D$rowIndex').setText(tour.netAmount.toString());
      sheet.getRangeByName('E$rowIndex').setText(tour.margin.toString());
    }

    // Calculate total values
    double totalInvoiceAmount = 0;
    double totalNetAmount = 0;
    double totalMargin = 0;

    for (var tour in tours) {
      totalInvoiceAmount += tour.invoiceAmount;
      totalNetAmount += tour.netAmount;
      totalMargin += tour.margin;
    }

    // Write total values to the last row of each numeric column
    final int lastRowIndex = tours.length + 3; // Move this line here

    sheet.getRangeByName('A$lastRowIndex').setText('Total:');
    sheet
        .getRangeByName('C$lastRowIndex')
        .setText(totalInvoiceAmount.toString());
    sheet.getRangeByName('D$lastRowIndex').setText(totalNetAmount.toString());
    sheet.getRangeByName('E$lastRowIndex').setText(totalMargin.toString());

    // Save workbook
    final Directory outputDir = await getTemporaryDirectory();
    final String filePath = '${outputDir.path}/tours_$monthYear.xlsx';
    final File file = File(filePath);

    // Save the workbook to the file
    final List<int> bytes = workbook.saveAsStream();
    try {
      await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error writing file: $e');
      // Handle the error (e.g., display an error message to the user)
    }

    // Dispose the workbook
    workbook.dispose();

    return file;
  }
}
