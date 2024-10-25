import 'package:flutter/material.dart';
import '../../../Services/maintenance_service.dart';
import '../../../utils/urlContants.dart';
import '../../../widgets/bottomNavigationBar.dart';

class LandlordMaintenanceScreen extends StatefulWidget {
  const LandlordMaintenanceScreen({super.key});

  @override
  _LandlordMaintenanceScreenState createState() => _LandlordMaintenanceScreenState();
}

class _LandlordMaintenanceScreenState extends State<LandlordMaintenanceScreen> {
  int _selectedIndex = 0;
  final MaintenanceService _maintenanceService = MaintenanceService(base_url);
  List<MaintenanceTicket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceTickets();
  }

  Future<void> _fetchMaintenanceTickets() async {
    try {
      final tickets = await _maintenanceService.fetchLandlordMaintenanceTickets();
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

  Future<void> _closeTicket(MaintenanceTicket ticket) async {
    try {
      // Implement your ticket closing logic here
      // await _maintenanceService.closeTicket(ticket.id);
      // Refresh the ticket list after closing the ticket
      await _fetchMaintenanceTickets();
    } catch (e) {
      print('Error closing ticket: $e');
    }
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
          title: const Text('Ticket Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...ticketDetails.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Text(
                          '${entry.key}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 10),
                // Display ticket image if it exists
                if (ticket.imageUrl != null && ticket.imageUrl!.isNotEmpty)
                  Column(
                    children: [
                      const Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Image.network(
                        ticket.imageUrl!,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return const Text('Image could not be loaded');
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
              child: const Text('Close Ticket'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                _closeTicket(ticket); // Call the close ticket function
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: const Text('Maintenance', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              // Handle user dropdown selection
            },
            child: const Row(
              children: [
                Text(
                  "Landlord",
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
            const Text(
              "Tickets",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                          child: const Text(
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
