import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toursapp/widget/add_new_sheet_widget.dart';
import 'package:toursapp/provider/tourdata.dart';
import 'package:toursapp/widget/clear_data_widget.dart';
import 'package:toursapp/widget/datagrid_table_widget.dart'; // Alias for data_table_source.dart
import 'package:toursapp/Service/db_helper.dart';
import 'package:toursapp/screen/add_dataform_screen.dart';
import 'package:toursapp/screen/login_screen.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/widget/changetable_header_form.dart';
import 'package:toursapp/provider/table_headers.dart';
// Import your state management class

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  _TourListScreenState createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  late TextEditingController _searchController;

  int selectedMonth = 4;
  int selectedYear = 2024;

  void fetchMonthTourData(context, int month, int year, String type) {
    Provider.of<TourData>(context, listen: false)
        .fetchMonthTourData(context, month, year, type);
    _updateTourData();
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
    var headerProvider = Provider.of<TableHeaders>(context);
    var tableProvider = Provider.of<TourData>(context);
    return Scaffold(
      //   leading: Row(
      // children: [
      //   IconButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => const LoginPage()),
      //       );
      //     },
      //     icon: const Icon(Icons.logout),
      //   ),
      //   const Text('Logout'),
      // ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String?>(
            context: context,
            builder: (context) => const NEWSHEETPopup(),
          );
        },
        child: const Icon(
          Icons.edit_document,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text('Logout'),
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  icon: const Icon(
                    Icons.exit_to_app,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 200,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/logo2.png',
                  width: 600,
                  height: 250,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Monthly Sheet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: const Text(
                            'Generate Report',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
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
                                    tableProvider.getMonthName(index + 1),
                                    style: const TextStyle(
                                      fontSize: 18,
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
                            const SizedBox(width: 10),
                            DropdownButton<int>(
                              value: selectedYear,
                              items: List.generate(10, (index) {
                                return DropdownMenuItem<int>(
                                  value: DateTime.now().year - index,
                                  child: Text(
                                    (DateTime.now().year - index).toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
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
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            fetchMonthTourData(
                                context, selectedMonth, selectedYear, 'PDF');
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                fetchMonthTourData(context, selectedMonth,
                                    selectedYear, 'EXCEL');
                              },
                              icon: const Icon(
                                Icons.insert_drive_file,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // fetchMonthTourData(
                                //     context, selectedMonth, selectedYear, 'PDF');
                                showDialog<String?>(
                                  context: context,
                                  builder: (context) => const NEWSHEETPopup(),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_document,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
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
                      backgroundColor: Colors.white,
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
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show the dialog and pass an empty Tour object

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ClearDataDialog();
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Clear Record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
                                    child: Text(headerProvider.name),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'reference',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.reference),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ticket',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.ticket),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'sector',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.sector),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'invoiceAmount',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.invoiceAmount),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'netAmount',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.netAmount),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'margin',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Text(headerProvider.margin),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'edit',
                                  label: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        const Text("Edit"),
                                        IconButton(
                                            onPressed: () {
                                              // navigation

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const TourFormHeaderDialog();
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 15,
                                            ))
                                      ],
                                    ),
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

  void _updateTourData() {
    Provider.of<TourData>(context, listen: false).fetchTours();
  }
}
