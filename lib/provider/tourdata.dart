import 'dart:async';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/widget/datagrid_table_widget.dart';
import 'package:toursapp/Service/db_helper.dart';
import 'package:toursapp/model/model.dart';

class TourData extends ChangeNotifier {
  final BuildContext context;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  final TourManager db = TourManager();
  late String _searchText = '';
  String get searchText => _searchText;

  late String _monthYear = '';

  String get monthYear => _monthYear;

  List<Tour> _tours = []; // Use Tour without a prefix
  List<Tour> get tours => _tours;

  TourData(this.context);

  Future<void> fetchTours() async {
    List<Tour> tours = await db.getTours();
    _tours = tours;
    notifyListeners();
  }

  // Delete a tour by id
  Future<void> deleteTour(String id) async {
    await db.deleteTour(id);
    _tours.removeWhere((tour) => tour.id == id);
    notifyListeners();
  }

  // Edit a tour by id
  Future<void> editTour(String id, Tour updatedTour) async {
    await db.updateTour(updatedTour);
    int index = _tours.indexWhere((tour) => tour.id == id);
    if (index != -1) {
      _tours[index] = updatedTour;
      notifyListeners();
    }
  }

  // Add a new tour
  Future<void> addTour(Tour newTour) async {
    await db.insertTour(newTour);
    _tours.add(newTour);
    notifyListeners();
  }

  // Update the search text
  void updateSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void DataClear(BuildContext context) async {
    await db.clearAllData();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data has been cleared')),
    );
    fetchTours();
    notifyListeners();
  }

  Future<void> fetchMonthTourData(
      BuildContext context, int month, int year, String type) async {
    _monthYear = '$month-$year';
    List<Tour> tours = await db.getToursForMonth(monthYear);
    _tours = tours;
    notifyListeners();
    if (type == 'PDF') {
      generatePDF(context, monthYear);
      notifyListeners();
    }
    // } else if (type == 'newsheet') {
    //   addSheetToExcel(context);
    //   notifyListeners();
    //  }
    else {
      generateExcel(context, monthYear);
      notifyListeners();
    }

    print(monthYear);
  }

  Future<void> generateExcel(BuildContext context, String monthYear) async {
    final File? excelFile = await db.generateExcelForMonth(context, monthYear);
    if (excelFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Excel generated: ${excelFile.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(excelFile.path);
            },
          ),
        ),
      );
    }
  }

//   Future<void> addSheetToExcel(
//     BuildContext context,
//   ) async {
//     final dataProvider = Provider.of<DataProvider>(context);
//     String selectedPath = dataProvider.selectedPath.toString();

//     final excelFile = File(selectedPath);
//     final List<int> fileBytes = await excelFile.readAsBytes();

//     var excel = Excel.decodeBytes(fileBytes); // Load existing workbook

//     var worksheetName = dataProvider.worksheetName;
//     if (worksheetName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please enter a worksheet name.")));
//       return;
//     }

//     // Add a new sheet with a unique name
//     if (!excel.sheets.containsKey(worksheetName)) {
//       excel.sheets[worksheetName] =
//           excel['Sheet1']; // Use a base sheet to create a new one
//     }

//     var sheet = excel[worksheetName];

//     sheet.cell(CellIndex.indexByString("A1")).value =
//         const TextCellValue("Date");
//     sheet.cell(CellIndex.indexByString("B1")).value =
//         const TextCellValue("Description");
//     sheet.cell(CellIndex.indexByString("C1")).value =
//         const TextCellValue("Invoice Amount");
//     sheet.cell(CellIndex.indexByString("D1")).value =
//         const TextCellValue("Net Amount");
//     sheet.cell(CellIndex.indexByString("E1")).value =
//         const TextCellValue("Margin");

//     // Write data to the new sheet
//     for (int i = 0; i < tours.length; i++) {
//       final Tour tour = tours[i];
//       final int rowIndex = i + 2; // Data starts from row 2 (headers on row 1)

//       sheet.cell(CellIndex.indexByString("A$rowIndex")).value =
//           TextCellValue(tour.date);
//       sheet.cell(CellIndex.indexByString("B$rowIndex")).value =
//           TextCellValue(tour.name);
//       sheet.cell(CellIndex.indexByString("C$rowIndex")).value =
//           TextCellValue(tour.invoiceAmount.toString());
//       sheet.cell(CellIndex.indexByString("D$rowIndex")).value =
//           TextCellValue(tour.netAmount.toString());
//       sheet.cell(CellIndex.indexByString("E$rowIndex")).value =
//           TextCellValue(tour.margin.toString());
//     }
// // Assigning a string

//     try {
//       final updatedBytes = excel.encode();
//       await excelFile.writeAsBytes(updatedBytes!);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("New sheet '$worksheetName' added to Excel.")));
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error adding sheet: $e")));
//     }
//   }

  

  Future<void> generatePDF(BuildContext context, String monthYear) async {
    final File? pdfFile = await db.generatePDFForMonth(context, monthYear);
    if (pdfFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF generated: ${pdfFile.path}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(pdfFile.path);
            },
          ),
        ),
      );
    }
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  // Future<void> generatePDF(BuildContext context, String monthYear) async {
  //   final File? pdfFile = await db.generatePDFForMonth(context,monthYear,);

  //   // Show a dialog with a message and options to open or close
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('PDF Generated'),
  //         content: Text(
  //           'PDF has been generated at the following path:\n\n${pdfFile.path}',
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Open the file with the default application
  //               OpenFile.open(pdfFile.path);
  //             },
  //             child: const Text('Open'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Close the dialog
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
