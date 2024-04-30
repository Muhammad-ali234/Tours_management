import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/Service/db_helper.dart';
import 'dart:io';

import 'package:toursapp/Service/db_helper.dart';

import 'package:toursapp/model/model.dart';

import 'package:toursapp/provider/tourdata.dart';

class NEWSHEETPopup extends StatefulWidget {
  const NEWSHEETPopup({super.key});

  @override
  _NEWSHEETPopupState createState() => _NEWSHEETPopupState();
}

class _NEWSHEETPopupState extends State<NEWSHEETPopup> {
  final TourManager db = TourManager();
  String? selectedPath;
  final TextEditingController _worksheetNameController =
      TextEditingController();

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedPath = result.files.single.path;
      });
    }
  }

  void cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourData>(context);
    return AlertDialog(
      title: const Text('Add a New Sheet to Excel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _worksheetNameController,
            decoration: const InputDecoration(
              labelText: 'Worksheet Name',
              hintText: 'Enter a name for the new sheet',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            // mainAxisize: MainAxisize.min,
            children: [
              Text(selectedPath ?? 'No path selected'),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _pickExcelFile,
                child: const Icon(Icons.folder_open),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: cancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // List<Tour> tours =
            //     await db.getToursForMonth(tourProvider.monthYear);
            db.newSheetToExcel(context, tourProvider.monthYear, selectedPath,
                _worksheetNameController);
            print(tourProvider.monthYear);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
