import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/data_table_source.dart';
import 'package:toursapp/db_helper.dart';
import 'package:toursapp/model.dart';

class TourData extends ChangeNotifier {
  final BuildContext context; // Added context here

  final bool _isLoading = false;
  bool get isLoading => _isLoading;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late String _searchText = '';
  String get searchText => _searchText;

  List<Tour> _tours = [];
  List<Tour> get tours => _tours;

  // Constructor with context parameter
  TourData(this.context);

  // Fetch tours from the database
  Future<void> fetchTours() async {
    List<Tour> tours = await _databaseHelper.getTours();
    _tours = tours;
    notifyListeners();
  }

  // Delete a tour by id
  Future<void> deleteTour(String id) async {
    await _databaseHelper.deleteTour(id);
    _tours.removeWhere((tour) => tour.id == id);
    notifyListeners();
  }

  // Edit a tour by id
  Future<void> editTour(String id, Tour updatedTour) async {
    await _databaseHelper.updateTour(updatedTour);
    int index = _tours.indexWhere((tour) => tour.id == id);
    if (index != -1) {
      _tours[index] = updatedTour;
      notifyListeners();
    }
  }

  // Add a new tour
  Future<void> addTour(Tour newTour) async {
    await _databaseHelper.insertTour(newTour);
    _tours.add(newTour);
    notifyListeners();
  }

  // Update the search text
  void updateSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  Future<void> fetchMonthTourData(
      BuildContext context, int month, int year, String type) async {
    final monthYear = '$month-$year';
    List<Tour> tours = await _databaseHelper.getToursForMonth(monthYear);
    _tours = tours;
    notifyListeners();
    if (type == 'PDF') {
      generatePDF(context, monthYear);
      notifyListeners();
    } else {
      generateExcel(context, monthYear);
      notifyListeners();
    }

    print(monthYear);
  }

  Future<void> generateExcel(BuildContext context, String monthYear) async {
    final File excelFile =
        await _databaseHelper.generateExcelForMonth(monthYear);
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

  String _getMonthName(int month) {
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

  Future<void> generatePDF(BuildContext context, String monthYear) async {
    final File pdfFile = await _databaseHelper.generatePDFForMonth(monthYear);
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
