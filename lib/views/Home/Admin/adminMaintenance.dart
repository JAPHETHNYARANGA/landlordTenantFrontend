import 'package:flutter/material.dart';
import '../../../Services/maintenance_service.dart'; // Import the MaintenanceService
import '../../../utils/urlContants.dart';
import '../../../widgets/bottomNavigationBar.dart';

class AdminMaintenanceScreen extends StatefulWidget {
  const AdminMaintenanceScreen({super.key});

  @override
  _AdminMaintenanceScreenState createState() => _AdminMaintenanceScreenState();
}

class _AdminMaintenanceScreenState extends State<AdminMaintenanceScreen> {
  int _selectedIndex = 0;
  final MaintenanceService _maintenanceService = MaintenanceService(base_url); // Replace with your API base URL
  List<MaintenanceTicket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceTickets();
  }

  Future<void> _fetchMaintenanceTickets() async {
    try {
      final tickets = await _maintenanceService.fetchMaintenanceTickets();
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showTicketDetailsDialog(MaintenanceTicket ticket) {
    final Map<String, String> ticketDetails = {
      'Ticket #': ticket.id.toString(),
      'Issue': ticket.issue,
      'Description': ticket.description,
      'Status': ticket.status,
      'Date Created': ticket.createdAt.toLocal().toString(),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ticket Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ticketDetails.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(entry.value),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Text('Maintenance', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              // Handle user dropdown selection
            },
            child: Row(
              children: [
                Text(
                  "ADMIN",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tickets",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(ticket.issue),
                        subtitle: Text(ticket.status),
                        trailing: TextButton(
                          onPressed: () {
                            _showTicketDetailsDialog(ticket);
                          },
                          child: Text(
                            'Details',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
