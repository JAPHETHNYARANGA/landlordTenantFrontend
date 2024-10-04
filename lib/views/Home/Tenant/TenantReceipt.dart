import 'package:flutter/material.dart';
import '../../../Services/maintenance_service.dart'; // Adjust the import as per your project structure

// Tenant Ticket Screen
class TenantTicketScreen extends StatefulWidget {
  const TenantTicketScreen({Key? key}) : super(key: key);

  @override
  _TenantTicketScreenState createState() => _TenantTicketScreenState();
}

class _TenantTicketScreenState extends State<TenantTicketScreen> {
  final List<Map<String, dynamic>> tickets = [];
  final MaintenanceService maintenanceService = MaintenanceService('https://your-api-url.com');

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final int tenantId = 2; // Example tenant ID
  final int propertyId = 2; // Example property ID

  void _raiseTicket() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Raise a Maintenance Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: _issueController,
                  decoration: InputDecoration(labelText: 'Issue', border: OutlineInputBorder()),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await maintenanceService.createTicket(
                        tenantId,
                        propertyId,
                        _issueController.text,
                        _descriptionController.text,
                      );
                      Navigator.pop(context);
                      await _fetchTickets(); // Refresh the ticket list
                      _issueController.clear();
                      _descriptionController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create ticket: ${e.toString()}')),
                      );
                    }
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

  Future<void> _fetchTickets() async {
    try {
      List<MaintenanceTicket> fetchedTickets = await maintenanceService.fetchMaintenanceTickets();
      setState(() {
        tickets.clear();
        tickets.addAll(fetchedTickets.map((ticket) => {
          'id': ticket.id,
          'category': ticket.issue,
          'status': ticket.status,
        }).toList());
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch tickets: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTickets(); // Fetch tickets when the screen is initialized
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
                    Text(ticket['id'].toString(), style: TextStyle(fontSize: 16)),
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
                      backgroundColor: ticket['status'] == 'closed' ? Colors.green : Colors.red,
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
    );
  }
}
