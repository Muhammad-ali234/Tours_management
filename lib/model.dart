class Tour {
  int? id;
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
    this.id,
    required this.ticket, // Changed parameter name from name to ticket
    required this.sector, // Added sector parameter
    required this.date,
    required this.name, // Added name parameter
    required this.reference, // Added reference parameter

    this.invoiceAmount = 0.0,
    this.netAmount = 0.0,
    this.margin = 0.0,
    required this.flagMonthYear,
  });

  // Convert the Tour object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticket': ticket, // Changed from name to ticket
      'sector': sector, // Added sector
      'date': date,
      'name': name, // Added name
      'reference': reference, // Added reference

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
      ticket: map['ticket'], // Changed from name to ticket
      sector: map['sector'], // Added sector
      date: map['date'],
      name: map['name'], // Added name
      reference: map['reference'], // Added reference

      invoiceAmount: map['invoiceAmount'] ?? 0.0,
      netAmount: map['netAmount'] ?? 0.0,
      margin: map['margin'] ?? 0.0,
      flagMonthYear: map['flagMonthYear'] ?? 0.0,
    );
  }
}
