import 'package:flutter/material.dart';
import '../../../widgets/bottomNavigationBar.dart';


class AdminMaintenanceScreen extends StatefulWidget {
  const AdminMaintenanceScreen({super.key});

  @override
  _AdminMaintenanceScreenState createState() => _AdminMaintenanceScreenState();
}

class _AdminMaintenanceScreenState extends State<AdminMaintenanceScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showTicketDetailsDialog(String ticketId) {
    // Sample ticket details
    final Map<String, String> ticketDetails = {
      'Ticket #': ticketId,
      'Raised by': 'John Doe',
      'Apartment': 'Lake View',
      'House No.': '207',
      'Land Lord': 'Mark Fang',
      'Date': '10-12-2024',
      'Message': 'Sink is leaking.',
      'Time': '9:30 am'
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
                if (entry.key == 'Message') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          entry.value,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Category",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with your dynamic data count
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(child: Text("Lake View")), // Replace with actual data
                            Expanded(child: Text("Plumbing")), // Replace with actual data
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _showTicketDetailsDialog('Ticket #001'); // Replace with actual ticket ID
                                },
                                child: Text(
                                  'Details',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
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
