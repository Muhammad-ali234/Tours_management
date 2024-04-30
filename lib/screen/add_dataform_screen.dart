import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/provider/table_headers.dart';
import 'package:toursapp/provider/tourdata.dart';
import 'package:uuid/uuid.dart'; // Import your state management class

class TourFormDialog extends StatefulWidget {
  final Tour? editedTour;
  final String? index;

  const TourFormDialog({super.key, this.editedTour, this.index});

  @override
  _TourFormDialogState createState() => _TourFormDialogState();
}

class _TourFormDialogState extends State<TourFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ticketController;
  late TextEditingController _sectorController;
  late TextEditingController _invoiceAmountController;
  late TextEditingController _netAmountController;
  late TextEditingController _nameController;
  late TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    _ticketController =
        TextEditingController(text: widget.editedTour?.ticket ?? '');
    _sectorController =
        TextEditingController(text: widget.editedTour?.sector ?? '');
    _invoiceAmountController = TextEditingController(
        text: widget.editedTour?.invoiceAmount.toString() ?? '');
    _netAmountController = TextEditingController(
        text: widget.editedTour?.netAmount.toString() ?? '');
    _nameController =
        TextEditingController(text: widget.editedTour?.name ?? '');
    _referenceController =
        TextEditingController(text: widget.editedTour?.reference ?? '');
  }

  @override
  Widget build(BuildContext context) {
    var headerProvider = Provider.of<TableHeaders>(context);
    return AlertDialog(
      title: Text(
        widget.editedTour != null ? 'Edit Tour' : 'Add New Tour',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: headerProvider.name,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _referenceController,
                  decoration: InputDecoration(
                    labelText: '${headerProvider.reference} optional',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ticketController,
                  decoration: InputDecoration(
                    labelText: '${headerProvider.ticket} optional ',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sectorController,
                  decoration: InputDecoration(
                    labelText: headerProvider.sector,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sector details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _invoiceAmountController,
                  decoration: InputDecoration(
                    labelText: headerProvider.invoiceAmount,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter invoice amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _netAmountController,
                  decoration: InputDecoration(
                    labelText: headerProvider.netAmount,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter net amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final now = DateTime.now();
              final newTour = Tour(
                id: const Uuid().v4(),
                ticket: _ticketController.text,
                sector: _sectorController.text,
                invoiceAmount: double.parse(_invoiceAmountController.text),
                netAmount: double.parse(_netAmountController.text),
                name: _nameController.text,
                reference: _referenceController.text,
                date: '${now.day}-${now.month}-${now.year}'.toString(),
                margin: double.parse(_invoiceAmountController.text) -
                    double.parse(_netAmountController.text),
                flagMonthYear: '${now.month}-${now.year}',
              );
              if (widget.editedTour != null) {
                final updatedTour = Tour(
                  id: widget.editedTour!.id,
                  ticket: _ticketController.text,
                  sector: _sectorController.text,
                  invoiceAmount: double.parse(_invoiceAmountController.text),
                  netAmount: double.parse(_netAmountController.text),
                  name: _nameController.text,
                  reference: _referenceController.text,
                  date: widget.editedTour!.date,
                  margin: double.parse(_invoiceAmountController.text) -
                      double.parse(_netAmountController.text),
                  flagMonthYear: widget.editedTour!.flagMonthYear,
                );
                Provider.of<TourData>(context, listen: false)
                    .editTour(widget.index!, updatedTour);
                Navigator.pop(context, updatedTour);
              } else {
                // Add new tour
                Provider.of<TourData>(context, listen: false).addTour(newTour);
                Navigator.pop(context, newTour);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ticketController.dispose();
    _sectorController.dispose();
    _invoiceAmountController.dispose();
    _netAmountController.dispose();
    _nameController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}
