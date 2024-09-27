import 'package:flutter/material.dart';
import '../../../widgets/bottomNavigationBar.dart';

class TenantTicketScreen extends StatefulWidget {
  const TenantTicketScreen({Key? key}) : super(key: key);

  @override
  _TenantTicketScreenState createState() => _TenantTicketScreenState();
}

class _TenantTicketScreenState extends State<TenantTicketScreen> {
  final List<Map<String, dynamic>> tickets = [
    {'id': '#123456', 'category': 'Plumbing', 'status': 'Closed'},
    {'id': '#123457', 'category': 'Electrical', 'status': 'Open'},
    {'id': '#123458', 'category': 'HVAC', 'status': 'Pending'},
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _raiseTicket() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Raise a Maintenance Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Logic to handle ticket submission
                    Navigator.pop(context);
                  },
                  child: Text('Submit Ticket'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ticketItem(Map<String, dynamic> ticket) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ticket ID", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(ticket['id'], style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(ticket['category'], style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Chip(
                      label: Text(ticket['status']),
                      backgroundColor: ticket['status'] == 'Closed' ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Tickets'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: _raiseTicket,
                child: Text("Raise Ticket"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return _ticketItem(tickets[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
