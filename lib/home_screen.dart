import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toursapp/db_helper.dart';
import 'package:toursapp/form_screen.dart';
import 'package:toursapp/model.dart';

class TourListScreen extends StatefulWidget {
  const TourListScreen({super.key});

  @override
  State<TourListScreen> createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  List<Tour>? tourData; // List to hold tour data, make it nullable
  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Instance of DatabaseHelper
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fetchTourData(); // Fetch tour data when the screen initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTourData(); // Fetch tour data when the dependencies change
  }

  // Method to fetch tour data from the database
  void fetchTourData() async {
    List<Tour> tours = await _databaseHelper.getTours();
    setState(() {
      tourData = tours;
    });
  }

  List<Tour> filteredTourData() {
    if (searchText.isEmpty) {
      return tourData ?? [];
    } else {
      return (tourData ?? []).where((tour) {
        return tour.name.toLowerCase().contains(searchText.toLowerCase()) ||
            (tour.reference.toLowerCase().contains(searchText.toLowerCase()));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
                Image.asset(
                  'assets/logo2.png',
                  width: 600,
                  height: 200,
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: const Center(
                child: Text(
                  'Monthly Sheet',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      ).then((_) {
                        // Refresh tour data after closing the dialog
                        fetchTourData();
                      });
                    },
                    child: const Text('Add New Record'),
                  ),
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by Name',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: tourData != null
                      ? searchText.isEmpty
                          ? buildDataTable(tourData!)
                          : buildDataTable(filteredTourData())
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build DataTable widget
  Widget buildDataTable(List<Tour> data) {
    return DataTable(
      columns: const [
        DataColumn(
          label: Text(
            'Date',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Name/Detail',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Reference',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Ticket',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Sector',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Invoice Amount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Net Amount',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Margin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            'Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      columnSpacing: 16,
      rows: data.map((tour) {
        return DataRow(cells: [
          DataCell(Text(tour.date)),
          DataCell(Text(tour.name)),
          DataCell(Text(tour.reference)),
          DataCell(Text(tour.ticket)),
          DataCell(Text(tour.sector)),
          DataCell(Text('${tour.invoiceAmount}')),
          DataCell(Text('${tour.netAmount}')),
          DataCell(Text('${tour.margin}')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  // Navigate to the form screen with the selected tour data for editing
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TourFormDialog(
                        editedTour: tour,
                        index: tour.id, // Pass the index here
                      ),
                    ),
                  ).then((_) {
                    // Refresh tour data after closing the dialog
                    fetchTourData();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Implement delete functionality here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Tour'),
                        content: const Text(
                            'Are you sure you want to delete this tour?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Delete the tour from the database
                              await _databaseHelper.deleteTour(tour.id!);
                              // Refresh tour data after deleting
                              fetchTourData();
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}
