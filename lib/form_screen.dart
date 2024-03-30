import 'package:flutter/material.dart';
import 'package:toursapp/db_helper.dart';
import 'package:toursapp/model.dart';

class TourFormDialog extends StatefulWidget {
  final Tour? editedTour;
  final int? index;

  const TourFormDialog({super.key, this.editedTour, this.index});

  @override
  _TourFormDialogState createState() => _TourFormDialogState();
}

class _TourFormDialogState extends State<TourFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ticketController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _invoiceAmountController =
      TextEditingController();
  final TextEditingController _netAmountController = TextEditingController();
  //final TextEditingController _marginController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _referenceController =
      TextEditingController(); // Add TextEditingController for reference

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    if (widget.editedTour != null) {
      _ticketController.text = widget.editedTour!.ticket;
      _sectorController.text = widget.editedTour!.sector;
      _invoiceAmountController.text =
          widget.editedTour!.invoiceAmount.toString();
      _netAmountController.text = widget.editedTour!.netAmount.toString();
      _nameController.text = widget.editedTour!.name;
      _referenceController.text = widget.editedTour!.reference;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Tour',
        style: TextStyle(fontWeight: FontWeight.bold),
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
                  controller: _ticketController,
                  decoration: const InputDecoration(
                    labelText: 'Ticket',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ticket details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
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
                  controller:
                      _referenceController, // Use the reference controller
                  decoration: const InputDecoration(
                    labelText: 'Reference',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter reference details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sectorController,
                  decoration: const InputDecoration(
                    labelText: 'Sector',
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
                  decoration: const InputDecoration(
                    labelText: 'Invoice Amount',
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
                  decoration: const InputDecoration(
                    labelText: 'Net Amount',
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
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              double invoiceAmount =
                  double.parse(_invoiceAmountController.text);
              double netAmount = double.parse(_netAmountController.text);
              double marginCalc = invoiceAmount - netAmount;

              final now = DateTime.now();
              final formattedDate = '${now.year}-${now.month}-${now.day}';
              final tour = Tour(
                ticket: _ticketController.text,
                sector: _sectorController.text,
                date: formattedDate,
                name: _nameController.text,
                reference: _referenceController.text,
                invoiceAmount: invoiceAmount,
                netAmount: netAmount,
                margin: marginCalc,
              );

              if (widget.editedTour != null) {
                tour.id = widget.editedTour!.id;
                await _databaseHelper.updateTour(tour);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tour data updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                await _databaseHelper.insertTour(tour);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tour data added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            }

            _ticketController.clear();
            _sectorController.clear();
            _invoiceAmountController.clear();
            _netAmountController.clear();

            _nameController.clear(); // Clear name field controller
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
}
