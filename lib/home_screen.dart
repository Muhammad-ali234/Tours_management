import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toursapp/data_table_source.dart'; // Alias for data_table_source.dart
import 'package:toursapp/db_helper.dart';
import 'package:toursapp/form_screen.dart';
import 'package:toursapp/model.dart';
import 'package:toursapp/tourdata.dart';
// Import your state management class

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  _TourListScreenState createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  late TextEditingController _searchController;

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  int selectedMonth = 4;
  int selectedYear = 2024;

  void fetchMonthTourData(context, int month, int year) {
    Provider.of<TourData>(context, listen: false)
        .fetchMonthTourData(context, month, year);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Provider.of<TourData>(context, listen: false).fetchTours();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/logo2.png',
                  width: 600,
                  height: 200,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: const Text(
                            'Generate Report',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: selectedMonth,
                              items: List.generate(12, (index) {
                                return DropdownMenuItem<int>(
                                  value: index + 1,
                                  child: Text(
                                    _getMonthName(index + 1),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedMonth = value!;
                                });
                              },
                              underline: Container(),
                            ),
                            DropdownButton<int>(
                              value: selectedYear,
                              items: List.generate(10, (index) {
                                return DropdownMenuItem<int>(
                                  value: DateTime.now().year - index,
                                  child: Text(
                                    (DateTime.now().year - index).toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedYear = value!;
                                });
                              },
                              underline: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              fetchMonthTourData(
                                  context, selectedMonth, selectedYear);
                            },
                            icon: const Icon(Icons.picture_as_pdf)),
                        const SizedBox(height: 5),
                        IconButton(
                            onPressed: () {
                              // Provider.of<TourData>(context, listen: false).generateExcel(context, _selectedMonth, _selectedYear);
                            },
                            icon: const Icon(Icons.abc))
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show the dialog and pass an empty Tour object
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const TourFormDialog();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      backgroundColor: Colors.blue,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add New Record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by Name',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      Provider.of<TourData>(context, listen: false)
                          .updateSearchText(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: const Center(
                child: Text(
                  'Monthly Sheet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<TourData>(
                builder: (context, tourData, _) {
                  return tourData.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : tourData.tours.isEmpty
                          ? const Center(child: Text('No data available'))
                          : SfDataGrid(
                              source: TourDataSource(
                                  tours: tourData.tours,
                                  searchText: tourData.searchText,
                                  context: context),
                              columnWidthMode: ColumnWidthMode.fill,
                              columns: <GridColumn>[
                                GridColumn(
                                  columnName: 'date',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Date'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'name',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Description'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'reference',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Reference'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ticket',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Ticket'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'sector',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Sector'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'invoiceAmount',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Invoice Amount'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'netAmount',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Net Amount'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'margin',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text('Margin'),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'edit',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text("Edit"),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'delete',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: const Text("Delete"),
                                  ),
                                ),
                              ],
                              rowHeight: 70,
                            );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
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

  void _updateTourData() {
    Provider.of<TourData>(context, listen: false).fetchTours();
  }
}
