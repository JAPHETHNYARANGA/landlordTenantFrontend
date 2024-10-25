import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Services/maintenance_service.dart';
import '../../../Services/authService.dart';
import '../../../utils/urlContants.dart';
import '../../../widgets/bottomNavigationBar.dart';
import 'dart:io';

class TenantTicketScreen extends StatefulWidget {
  const TenantTicketScreen({Key? key}) : super(key: key);

  @override
  _TenantTicketScreenState createState() => _TenantTicketScreenState();
}

class _TenantTicketScreenState extends State<TenantTicketScreen> {
  final MaintenanceService _maintenanceService = MaintenanceService(base_url);
  final AuthService _authService = AuthService();
  List<MaintenanceTicket> tickets = [];
  int _selectedIndex = 0;

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? tenantId;
  int? propertyId;
  File? _image;
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchTickets();
  }

  Future<void> _fetchUser() async {
    try {
      final userInfo = await _authService.fetchUser();
      setState(() {
        tenantId = userInfo['user']['id'];
        propertyId = userInfo['user']['property_id'];
      });
    } catch (error) {
      print('Error fetching user info: $error');
    }
  }

  Future<void> _fetchTickets() async {
    try {
      final fetchedTickets = await _maintenanceService.fetchTenantMaintenanceTickets();
      setState(() {
        tickets = fetchedTickets;
      });
    } catch (error) {
      print('Error fetching tickets: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }

    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  void _raiseTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Raise a Maintenance Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _issueController,
                    decoration: const InputDecoration(labelText: 'Issue', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_image != null) ...[
                    const Text('Image Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _image!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (tenantId != null && propertyId != null) {
                        try {
                          await _maintenanceService.createTicket(
                            tenantId!,
                            propertyId!,
                            _issueController.text,
                            _descriptionController.text,
                            _image,
                          );
                          Navigator.pop(context); // Close the modal
                          await _fetchTickets(); // Refresh tickets after submission
                        } catch (error) {
                          print('Error submitting ticket: $error');
                        }
                      } else {
                        print('Tenant ID or Property ID is null');
                      }
                    },
                    child: const Text('Submit Ticket'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _ticketItem(MaintenanceTicket ticket) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailScreen(ticket: ticket, onDelete: _fetchTickets),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      const Text("Ticket ID", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('#${ticket.id}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Issue", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(ticket.issue, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(ticket.status),
                        backgroundColor: ticket.status.toLowerCase() == 'closed' ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Tickets'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: _raiseTicket,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Raise Ticket"),
              ),
            ],
          ),
          Expanded(
            child: tickets.isEmpty
                ? Center(
              child: Text(
                'No tickets available here.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
                : ListView.builder(
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

// Ticket Detail Screen
class TicketDetailScreen extends StatelessWidget {
  final MaintenanceTicket ticket;
  final Function onDelete;

  const TicketDetailScreen({Key? key, required this.ticket, required this.onDelete}) : super(key: key);

  Future<void> _deleteTicket(BuildContext context) async {
    final MaintenanceService _maintenanceService = MaintenanceService(base_url);
    try {
      await _maintenanceService.deleteTicket(ticket.id);
      Navigator.pop(context);
      onDelete();
    } catch (error) {
      print('Error deleting ticket: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ticket ID: #${ticket.id}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Issue: ${ticket.issue}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Description: ${ticket.description}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Status: ${ticket.status}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text("Created At: ${ticket.createdAt.toLocal().toString().split(' ')[0]}", style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text("Updated At: ${ticket.updatedAt.toLocal().toString().split(' ')[0]}", style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),

            // Display the image if it exists
            if (ticket.imageUrl != null && ticket.imageUrl!.isNotEmpty) ...[
              const Text('Image:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Image.network(
                ticket.imageUrl!,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
            ],

            ElevatedButton(
              onPressed: () => _deleteTicket(context),
              child: const Text('Delete Ticket', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
