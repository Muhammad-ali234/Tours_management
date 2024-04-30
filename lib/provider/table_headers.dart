import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableHeaders with ChangeNotifier {
  // Default values
  String _name = 'name';
  String _reference = 'reference';
  String _ticket = 'ticket';
  String _sector = 'sector';
  String _invoiceAmount = 'invoiceAmount';
  String _netAmount = 'netAmount';
  String _margin = 'margin';

  TableHeaders() {
    _loadFromPreferences();
  }

  void _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? _name;
    _reference = prefs.getString('reference') ?? _reference;
    _ticket = prefs.getString('ticket') ?? _ticket;
    _sector = prefs.getString('sector') ?? _sector;
    _invoiceAmount = prefs.getString('invoiceAmount') ?? _invoiceAmount;
    _netAmount = prefs.getString('netAmount') ?? _netAmount;
    _margin = prefs.getString('margin') ?? _margin;
    notifyListeners();
  }

  // Getters
  String get name => _name;
  String get reference => _reference;
  String get ticket => _ticket;
  String get sector => _sector;
  String get invoiceAmount => _invoiceAmount;
  String get netAmount => _netAmount;
  String get margin => _margin;

  // Setters with persistence
  void setName(String? name) async {
    if (name != null) {
      _name = name;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
    }
  }

  void setReference(String reference) async {
    _reference = reference;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('reference', reference);
  }

  void setTicket(String ticket) async {
    _ticket = ticket;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ticket', ticket);
  }

  void setSector(String sector) async {
    _sector = sector;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sector', sector);
  }

  void setInvoiceAmount(String invoiceAmount) async {
    _invoiceAmount = invoiceAmount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('invoiceAmount', invoiceAmount);
  }

  void setNetAmount(String netAmount) async {
    _netAmount = netAmount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Net Amount', netAmount);
  }

  void setMargin(String margin) async {
    _margin = margin;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('margin', margin);
  }
}
