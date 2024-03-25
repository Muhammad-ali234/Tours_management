import 'package:flutter/material.dart';

void main() {
  runApp(const TourManagementApp());
}

class TourManagementApp extends StatelessWidget {
  const TourManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TourListScreen(),
    );
  }
}

class TourListScreen extends StatelessWidget {
  // Dummy list of tours
  final List<Tour> tours = [
    Tour(
      name: 'Tour 1',
      date: DateTime(2024, 3, 25),
      checkOut: 'Location 1',
      pnr: '123456',
      seatGroup: 'A1',
      invoiceAmount: 100.0,
      netAmount: 90.0,
      margin: 10.0,
    ),
    Tour(
      name: 'Tour 2',
      date: DateTime(2024, 3, 26),
      checkOut: 'Location 2',
      pnr: '789012',
      seatGroup: 'B2',
      invoiceAmount: 150.0,
      netAmount: 120.0,
      margin: 30.0,
    ),
    Tour(
      name: 'Tour 3',
      date: DateTime(2024, 3, 25),
      checkOut: 'Location 1',
      pnr: '123456',
      seatGroup: 'A1',
      invoiceAmount: 100.0,
      netAmount: 90.0,
      margin: 10.0,
    ),
    Tour(
      name: 'Tour 4',
      date: DateTime(2024, 3, 26),
      checkOut: 'Location 2',
      pnr: '789012',
      seatGroup: 'B2',
      invoiceAmount: 150.0,
      netAmount: 120.0,
      margin: 30.0,
    ),
    Tour(
      name: 'Tour 5',
      date: DateTime(2024, 3, 25),
      checkOut: 'Location 1',
      pnr: '123456',
      seatGroup: 'A1',
      invoiceAmount: 100.0,
      netAmount: 90.0,
      margin: 10.0,
    ),
    Tour(
      name: 'Tour 6',
      date: DateTime(2024, 3, 26),
      checkOut: 'Location 2',
      pnr: '789012',
      seatGroup: 'B2',
      invoiceAmount: 150.0,
      netAmount: 120.0,
      margin: 30.0,
    ),
    Tour(
      name: 'Tour 7',
      date: DateTime(2024, 3, 25),
      checkOut: 'Location 1',
      pnr: '123456',
      seatGroup: 'A1',
      invoiceAmount: 100.0,
      netAmount: 90.0,
      margin: 10.0,
    ),
    Tour(
      name: 'Tour 8',
      date: DateTime(2024, 3, 26),
      checkOut: 'Location 2',
      pnr: '789012',
      seatGroup: 'B2',
      invoiceAmount: 150.0,
      netAmount: 120.0,
      margin: 30.0,
    ),
  ];

  TourListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Wardet AI Khan Tours L.L.C Branch: 1',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Al Ghuwair Market Rolla, Sharjah-U.A.E',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Email: alkhanbranch1@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mob: 0555221216 | 0569151280',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: const Center(
                      child: Text(
                        'Monthly Sheet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddTourScreen(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // Background color
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              // Button padding
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color:
                                        Colors.black), // Button border radius
                              ),
                            ),
                          ),
                          child: const Text('Add New Record'),
                        ),
                      ),
                      Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            suffixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            // Implement search functionality here
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    kBottomNavigationBarHeight,
                width: double.infinity,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Check/Out')),
                        DataColumn(label: Text('PNR')),
                        DataColumn(label: Text('Seat/Group')),
                        DataColumn(label: Text('Invoice Amount')),
                        DataColumn(label: Text('Net Amount')),
                        DataColumn(label: Text('Margin')),
                        DataColumn(
                            label: Text('Actions')), // Added column for actions
                      ],
                      columnSpacing: 16,
                      rows: tours.map((tour) {
                        return DataRow(cells: [
                          DataCell(Text(tour.name ?? '')),
                          DataCell(Text(tour.date?.toString() ?? '')),
                          DataCell(Text(tour.checkOut ?? '')),
                          DataCell(Text(tour.pnr ?? '')),
                          DataCell(Text(tour.seatGroup ?? '')),
                          DataCell(Text(
                              '\$${tour.invoiceAmount?.toStringAsFixed(2) ?? ''}')),
                          DataCell(Text(
                              '\$${tour.netAmount?.toStringAsFixed(2) ?? ''}')),
                          DataCell(Text(
                              '\$${tour.margin?.toStringAsFixed(2) ?? ''}')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  // Implement view functionality here
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Implement update functionality here
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Implement delete functionality here
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTourScreen extends StatelessWidget {
  const AddTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tour'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TourForm(),
      ),
    );
  }
}

class TourForm extends StatefulWidget {
  const TourForm({super.key});

  @override
  _TourFormState createState() => _TourFormState();
}

class _TourFormState extends State<TourForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _pnrController = TextEditingController();
  final TextEditingController _seatGroupController = TextEditingController();
  final TextEditingController _invoiceAmountController =
      TextEditingController();
  final TextEditingController _netAmountController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter tour name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Date'),
            validator: (value) {
              // Add date validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _checkOutController,
            decoration: const InputDecoration(labelText: 'C/O'),
            validator: (value) {
              // Add check-out validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _pnrController,
            decoration: const InputDecoration(labelText: 'PNR'),
            validator: (value) {
              // Add PNR validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _seatGroupController,
            decoration: const InputDecoration(labelText: 'S/G'),
            validator: (value) {
              // Add seat/group validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _invoiceAmountController,
            decoration: const InputDecoration(labelText: 'Invoice Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              // Add invoice amount validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _netAmountController,
            decoration: const InputDecoration(labelText: 'Net Amount'),
            keyboardType: TextInputType.number,
            validator: (value) {
              // Add net amount validation if needed
              return null;
            },
          ),
          TextFormField(
            controller: _marginController,
            decoration: const InputDecoration(labelText: 'Margin'),
            keyboardType: TextInputType.number,
            validator: (value) {
              // Add margin validation if needed
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save tour details and navigate back to tour list
                Tour newTour = Tour(
                  name: _nameController.text,
                  date: DateTime.parse(_dateController.text),
                  checkOut: _checkOutController.text,
                  pnr: _pnrController.text,
                  seatGroup: _seatGroupController.text,
                  invoiceAmount: double.parse(_invoiceAmountController.text),
                  netAmount: double.parse(_netAmountController.text),
                  margin: double.parse(_marginController.text),
                );

                // Pass the new tour back to the previous screen
                Navigator.pop(context, newTour);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _checkOutController.dispose();
    _pnrController.dispose();
    _seatGroupController.dispose();
    _invoiceAmountController.dispose();
    _netAmountController.dispose();
    _marginController.dispose();
    super.dispose();
  }
}

class Tour {
  final String? name;
  final DateTime? date;
  final String? checkOut;
  final String? pnr;
  final String? seatGroup;
  final double? invoiceAmount;
  final double? netAmount;
  final double? margin;

  Tour({
    this.name,
    this.date,
    this.checkOut,
    this.pnr,
    this.seatGroup,
    this.invoiceAmount,
    this.netAmount,
    this.margin,
  });
}
