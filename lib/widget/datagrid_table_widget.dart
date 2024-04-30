import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toursapp/screen/add_dataform_screen.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/provider/table_headers.dart';
import 'package:toursapp/provider/tourdata.dart'; // Import your state management class

class TourDataSource extends DataGridSource {
  List<Tour>? toursData;
  String searchText;
  final BuildContext context;
  final TourData _tourData;

  TourDataSource({
    List<Tour>? tours,
    required this.searchText,
    required this.context,
  }) : _tourData = Provider.of<TourData>(context, listen: false) {
    _initializeDataSource(tours);
  }

  void _initializeDataSource(List<Tour>? tours) {
    if (tours != null) {
      if (searchText.isEmpty) {
        toursData = tours;
      } else {
        toursData = filteredTourData(tours, searchText);
      }
    } else {
      toursData = [];
    }
  }

  void updateDataSource(List<Tour> tours) {
    toursData = tours;
    notifyListeners();
  }

  // Define a method to filter the tour data based on search text
  List<Tour> filteredTourData(List<Tour> tours, String searchText) {
    return tours.where((tour) {
      return tour.name.toLowerCase().contains(searchText.toLowerCase()) ||
          tour.reference.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  void _deleteTour(String id, List<Tour> tours) {
    try {
      _tourData.deleteTour(id);
      updateDataSource(tours);
      notifyListeners();
    } catch (e) {
      print("Error deleting tour: $e");
    }
  }

  void _navigateToEditTour(Tour editedTour) {
    int index = toursData!.indexWhere((tour) => tour.id == editedTour.id);
    if (index != -1) {
      toursData![index] = editedTour; // Update the tour in the list
      notifyListeners();
    }
  }

  @override
  List<DataGridRow> get rows {
    var headerProvider = Provider.of<TableHeaders>(context);
    return toursData!.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: e.date.toString()),
        DataGridCell<String>(columnName: headerProvider.name, value: e.name),
        DataGridCell<String>(
            columnName: headerProvider.reference, value: e.reference),
        DataGridCell<String>(
            columnName: headerProvider.ticket, value: e.ticket),
        DataGridCell<String>(
            columnName: headerProvider.sector, value: e.sector),
        DataGridCell<String>(
            columnName: headerProvider.invoiceAmount,
            value: e.invoiceAmount.toString()),
        DataGridCell<String>(
            columnName: headerProvider.netAmount,
            value: e.netAmount.toString()),
        DataGridCell<String>(columnName: 'margin', value: e.margin.toString()),
        // Add delete and edit icons here
        DataGridCell<String>(
          columnName: 'edit',
          value: e.id,
        ),
        DataGridCell<String>(
          columnName: 'delete',
          value: e.id,
        ),
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if (e.columnName == 'edit' || e.columnName == 'delete') {
          // Return icons for edit and delete columns
          return IconButton(
            icon: Icon(
              e.columnName == 'edit' ? Icons.edit : Icons.delete,
              color: Colors.blue, // Adjust icon colors as needed
            ),
            onPressed: () {
              if (e.columnName == 'edit') {
                String id = e.value;
                int index = toursData!.indexWhere((tour) => tour.id == id);
                if (index != -1) {
                  Tour selectedTour = toursData![index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TourFormDialog(
                        editedTour: selectedTour,
                        index: selectedTour.id, // Pass the index here
                      ),
                    ),
                  ).then((updatedTour) {
                    if (updatedTour != null) {
                      _navigateToEditTour(updatedTour);
                    }
                  });
                }
              } else if (e.columnName == 'delete') {
                print(e.value);
                String id = e.value;

                _deleteTour(id, toursData!);
              }
            },
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }
      }).toList(),
    );
  }
}
