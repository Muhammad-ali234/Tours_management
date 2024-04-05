import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toursapp/form_screen.dart';
import 'package:toursapp/model.dart';
import 'package:toursapp/tourdata.dart'; // Import your state management class

class TourDataSource extends DataGridSource {
  List<Tour>? toursData;
  String searchText;
  final BuildContext context;
  final TourData _tourData;

  TourDataSource({
    required List<Tour>? tours,
    required this.searchText,
    required this.context,
  }) : _tourData = Provider.of<TourData>(context, listen: false) {
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

  // Define a method to filter the tour data based on search text
  List<Tour> filteredTourData(List<Tour> tours, String searchText) {
    return tours.where((tour) {
      return tour.name.toLowerCase().contains(searchText.toLowerCase()) ||
          tour.reference.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }

  void deleteTour(int index) async {
    if (toursData != null && index >= 0 && index < toursData!.length) {
      int? id = toursData![index].id;
      if (id != null) {
        await _tourData.deleteTour(id);
        toursData!.removeAt(index);
        notifyListeners();
      }
    }
  }

  void editTour(int index, Tour updatedTour) async {
    if (toursData != null && index >= 0 && index < toursData!.length) {
      int? id = toursData![index].id;
      if (id != null) {
        await _tourData.editTour(id, updatedTour);
        toursData![index] = updatedTour;
        notifyListeners();
      }
    }
  }

  void _navigateToEditTour(Tour editedTour) async {
    int index = toursData!.indexWhere((tour) => tour.id == editedTour.id);
    if (index != -1) {
      toursData![index] = editedTour; // Update the tour in the list
      notifyListeners();
    }
  }

  @override
  List<DataGridRow> get rows {
    return toursData!.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: e.date.toString()),
        DataGridCell<String>(columnName: 'name', value: e.name),
        DataGridCell<String>(columnName: 'reference', value: e.reference),
        DataGridCell<String>(columnName: 'ticket', value: e.ticket),
        DataGridCell<String>(columnName: 'sector', value: e.sector),
        DataGridCell<String>(
            columnName: 'invoiceAmount', value: e.invoiceAmount.toString()),
        DataGridCell<String>(
            columnName: 'netAmount', value: e.netAmount.toString()),
        DataGridCell<String>(columnName: 'margin', value: e.margin.toString()),
        // Add delete and edit icons here
        DataGridCell<String>(
          columnName: 'edit',
          value: e.id.toString(),
        ),
        DataGridCell<String>(
          columnName: 'delete',
          value: e.id.toString(),
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
                int id = int.parse(e.value);
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
                int id = int.parse(e.value);
                int index = toursData!.indexWhere((tour) => tour.id == id);
                if (index != -1) {
                  deleteTour(index);
                }
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
