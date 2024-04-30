import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toursapp/model/model.dart';
import 'package:toursapp/provider/table_headers.dart';
import 'package:uuid/uuid.dart'; // Import your state management class

class TourFormHeaderDialog extends StatefulWidget {
  const TourFormHeaderDialog({
    super.key,
  });

  @override
  _TourFormHeaderDialogState createState() => _TourFormHeaderDialogState();
}

class _TourFormHeaderDialogState extends State<TourFormHeaderDialog> {
  TextEditingController? _ticketController;
  TextEditingController? _sectorController;
  TextEditingController? _invoiceAmountController;
  TextEditingController? _netAmountController;
  TextEditingController? _nameController;
  TextEditingController? _referenceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _referenceController = TextEditingController();
    _invoiceAmountController = TextEditingController();
    _sectorController = TextEditingController();
    _ticketController = TextEditingController();
    _netAmountController =
        TextEditingController(); // Ensure this is initialized
  }

  @override
  Widget build(BuildContext context) {
    var headerProvider = Provider.of<TableHeaders>(context);
    return AlertDialog(
      title: const Text(
        'Edit Tour Table Header',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: headerProvider.name,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _referenceController,
                decoration: InputDecoration(
                  labelText: headerProvider.reference,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ticketController,
                decoration: InputDecoration(
                  labelText: headerProvider.ticket,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _sectorController,
                decoration: InputDecoration(
                  labelText: headerProvider.sector,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _invoiceAmountController,
                decoration: InputDecoration(
                  labelText: headerProvider.invoiceAmount,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _netAmountController,
                decoration: InputDecoration(
                  labelText: headerProvider.netAmount,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
            ],
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
            if (_nameController!.text.isNotEmpty) {
              headerProvider.setName(_nameController!.text);
            }
            if (_referenceController!.text.isNotEmpty) {
              headerProvider.setReference(_referenceController!.text);
            }

            if (_invoiceAmountController!.text.isNotEmpty) {
              headerProvider.setInvoiceAmount(_invoiceAmountController!.text);
            }

            if (_sectorController!.text.isNotEmpty) {
              headerProvider.setSector(_sectorController!.text);
            }
            if (_ticketController!.text.isNotEmpty) {
              headerProvider.setTicket(_ticketController!.text);
            }
            if (_netAmountController!.text.isNotEmpty) {
              headerProvider.setNetAmount(_netAmountController!.text);
            }

            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (_ticketController != null) {
      _ticketController!.dispose();
    }

    if (_sectorController != null) {
      _sectorController!.dispose();
    }

    if (_invoiceAmountController != null) {
      _invoiceAmountController!.dispose();
    }

    if (_netAmountController != null) {
      _netAmountController!.dispose();
    }

    if (_nameController != null) {
      _nameController!.dispose();
    }

    if (_referenceController != null) {
      _referenceController!.dispose();
    }

    super.dispose(); // Call super.dispose() at the end
  }
}
