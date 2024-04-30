import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/Service/db_helper.dart';
import 'package:toursapp/provider/tourdata.dart';
class ClearDataDialog extends StatefulWidget {
  const ClearDataDialog({super.key});

  @override
  State<ClearDataDialog> createState() => _ClearDataDialogState();
}

class _ClearDataDialogState extends State<ClearDataDialog> {
  @override
  Widget build(BuildContext context) {
    TourData provider = Provider.of<TourData>(context);

    return AlertDialog(
      title: const Text('Clear All Data'),
      content: const Text(
          'Are you sure you want to clear all stored data? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without clearing
          },
          child: const Text('No'), // No button
        ),
        TextButton(
          onPressed: () {
            provider.DataClear(context);
          },
          child: const Text('Yes'), // Yes button
        ),
      ],
    );
  }

  void notifylistener() {}
}
