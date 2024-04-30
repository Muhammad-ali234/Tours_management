import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/widget/popup_widget_path_selection.dart';
import 'package:toursapp/provider/table_headers.dart';

class TourManager {
  SharedPreferences? _preferences;

  Future<SharedPreferences> _getPreferences() async {
    if (_preferences != null) {
      return _preferences!;
    } else {
      _preferences = await SharedPreferences.getInstance();
      return _preferences!;
    }
  }

  Future<int> insertTour(Tour tour) async {
    final SharedPreferences preferences = await _getPreferences();
    List<Tour> tours = await getTours();
    tours.add(tour);
    return await preferences.setString(
            'tours', jsonEncode(tours.map((e) => e.toMap()).toList()))
        ? 1
        : 0;
  }

  Future<List<Tour>> getTours() async {
    final SharedPreferences preferences = await _getPreferences();
    String? toursJson = preferences.getString('tours');
    if (toursJson != null) {
      List<dynamic> toursList = jsonDecode(toursJson);
      return List<Tour>.from(
          toursList.map((e) => Tour.fromMap(Map<String, dynamic>.from(e))));
    } else {
      return [];
    }
  }

  Future<void> updateTour(Tour editedTour) async {
    final SharedPreferences preferences = await _getPreferences();
    List<Tour> tours = await getTours();
    int index = tours.indexWhere((tour) => tour.id == editedTour.id);
    if (index != -1) {
      tours[index] = editedTour;
      await preferences.setString(
          'tours', jsonEncode(tours.map((e) => e.toMap()).toList()));
    }
  }

  Future<int> deleteTour(String? id) async {
    if (id == null) {
      throw ArgumentError('id cannot be null');
    }
    final SharedPreferences preferences = await _getPreferences();
    List<Tour> tours = await getTours();
    tours.removeWhere((tour) => tour.id == id);
    return await preferences.setString(
            'tours', jsonEncode(tours.map((e) => e.toMap()).toList()))
        ? 1
        : 0;
  }

  Future<List<Tour>> getToursForMonth(String monthYear) async {
    List<Tour> tours = await getTours();
    return tours.where((tour) => tour.flagMonthYear == monthYear).toList();
  }

  Future<void> clearAllData() async {
    final SharedPreferences preferences = await _getPreferences();
    await preferences.clear();
  }

  Future<File?> generatePDFForMonth(BuildContext context, monthYear) async {
    var headerProvider = Provider.of<TableHeaders>(context, listen: false);
    final List<Tour> tours = await getToursForMonth(monthYear);

    String? selectedPath = await showDialog<String?>(
      context: context,
      builder: (context) => const PathSelectorPopup(),
    );

    if (selectedPath == null) {
      return null; // User canceled
    }
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
                        child: pw.Text(headerProvider.name,
                            style: const pw.TextStyle(color: PdfColors.blue)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(headerProvider.invoiceAmount,
                            style: const pw.TextStyle(color: PdfColors.green)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.center,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(headerProvider.netAmount,
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
                    pw.Text(
                        'Total ${headerProvider.invoiceAmount}+ Amount: $totalInvoiceAmount'),
                    pw.Text(
                        'Total ${headerProvider.netAmount}: $totalNetAmount'),
                    pw.Text('Total Margin: $totalMargin'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final file = File('$selectedPath/tours_$monthYear.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File?> generateExcelForMonth(
      BuildContext context, String monthYear) async {
    final List<Tour> tours = await getToursForMonth(monthYear);
    var headerProvider = Provider.of<TableHeaders>(context, listen: false);

    String? selectedPath = await showDialog<String>(
      context: context,
      builder: (context) => const PathSelectorPopup(),
    );

    if (selectedPath == null) {
      return null; // User canceled
    }

    final excel = Excel.createExcel(); // Create a new Excel workbook
    final sheet = excel['Sheet1']; // Default sheet

    // Set the headers for Date, Description, Invoice amount, Net Amount, and Margin
    sheet.appendRow([
      const TextCellValue('Date'),
      TextCellValue(headerProvider.name),
      TextCellValue(headerProvider.invoiceAmount),
      TextCellValue(headerProvider.netAmount),
      const TextCellValue('Margin')
    ]);

    // Write tour data to the Excel sheet
    for (final tour in tours) {
      sheet.appendRow([
        TextCellValue(tour.date),
        TextCellValue(tour.name),
        TextCellValue(tour.invoiceAmount.toString()),
        TextCellValue(tour.netAmount.toString()),
        TextCellValue(tour.margin.toString())
      ]);
    }

    // Calculate total values
    double totalInvoiceAmount =
        tours.fold(0, (prev, tour) => prev + tour.invoiceAmount);
    double totalNetAmount =
        tours.fold(0, (prev, tour) => prev + tour.netAmount);
    double totalMargin = tours.fold(0, (prev, tour) => prev + tour.margin);

    // Add a row for totals
    sheet.appendRow([
      const TextCellValue('Total:'),
      const TextCellValue(''), // Description column
      TextCellValue(totalInvoiceAmount.toString()), // Invoice amount column
      TextCellValue(totalNetAmount.toString()),
      TextCellValue(totalMargin.toString())
    ]);

    // Save workbook to the file
    final String filePath = '$selectedPath/tours_$monthYear.xlsx';
    final File file = File(filePath);
    final List<int> bytes = excel.encode()!;
    await file.writeAsBytes(bytes);

    return file;
  }

  Future<void> newSheetToExcel(
      BuildContext context, monthYear, selectedPath, controller) async {
    final List<Tour> tours = await getToursForMonth(monthYear);
    if (selectedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an Excel file first.")));
      return;
    }

    final excelFile = File(selectedPath!);
    final List<int> fileBytes = await excelFile.readAsBytes();

    var excel = Excel.decodeBytes(fileBytes); // Load existing workbook

    var worksheetName = controller.text;
    if (worksheetName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a worksheet name.")));
      return;
    }

    // Add a new sheet with a unique name
    if (!excel.sheets.containsKey(worksheetName)) {
      excel.sheets[worksheetName] =
          excel['Sheet1']; // Use a base sheet to create a new one
    }

    var sheet = excel[worksheetName];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        const TextCellValue("Monthly Sheet");

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        const TextCellValue("Date");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        const TextCellValue("Description");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value =
        const TextCellValue("Invoice Amount");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value =
        const TextCellValue("Net Amount");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 1)).value =
        const TextCellValue("Margin");

    for (int i = 0; i < tours.length; i++) {
      final Tour tour = tours[i];
      final int rowIndex = i + 2; // Row index starting from 2

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = TextCellValue(tour.date);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = TextCellValue(tour.name);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = TextCellValue(tour.invoiceAmount.toString());
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = TextCellValue(tour.netAmount.toString());
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = TextCellValue(tour.margin.toString());
    }
    try {
      final updatedBytes = excel.encode();
      await excelFile.writeAsBytes(updatedBytes!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("New sheet '$worksheetName' added to Excel.")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding sheet: $e")));
    }
  }
}
