import 'package:uuid/uuid.dart';

class Tour {
  String id;
  String ticket;
  String sector;
  String date;
  String name;
  double invoiceAmount;
  double netAmount;
  double margin;
  String reference;
  String flagMonthYear;

  Tour({
    required this.id,
    required this.ticket,
    required this.sector,
    required this.invoiceAmount,
    required this.netAmount,
    required this.name,
    required this.reference,
    required this.date,
    required this.margin,
    required this.flagMonthYear,
  }); // Generate unique ID using UUID

  // Convert the Tour object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticket': ticket,
      'sector': sector,
      'date': date,
      'name': name,
      'reference': reference,
      'invoiceAmount': invoiceAmount,
      'netAmount': netAmount,
      'margin': margin,
      'flagMonthYear': flagMonthYear
    };
  }

  // Convert a map to a Tour object
  static Tour fromMap(Map<String, dynamic> map) {
    return Tour(
      id: map['id'],
      ticket: map['ticket'],
      sector: map['sector'],
      date: map['date'],
      name: map['name'],
      reference: map['reference'],
      invoiceAmount: map['invoiceAmount'] ?? 0.0,
      netAmount: map['netAmount'] ?? 0.0,
      margin: map['margin'] ?? 0.0,
      flagMonthYear: map['flagMonthYear'] ?? '', // Ensure it's a String
    );
  }
}
