import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<void> saveExcelFile(
    BuildContext context, String monthYear, List<int> bytes) async {
  TextEditingController controller = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Save Excel File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'File Name'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final String fileName = controller.text;
              if (fileName.isNotEmpty) {
                String filePath =
                    await FilePicker.platform.getDirectoryPath() ?? '';
                if (filePath.isNotEmpty) {
                  String fullPath = '$filePath/$fileName.xlsx';
                  final File file = File(fullPath);
                  await file.writeAsBytes(bytes);
                  Navigator.of(context).pop();
                } else {
                  // Handle case where no directory is selected
                }
              } else {
                // Handle case where no file name is provided
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
