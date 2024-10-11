import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Services/maintenance_service.dart';
import '../../../Services/authService.dart'; // Import AuthService
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
  final AuthService _authService = AuthService(); // Initialize AuthService
  List<MaintenanceTicket> tickets = [];
  int _selectedIndex = 0;

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int? tenantId;
  int? propertyId;
  File? _image; // Variable to hold the selected image

  @override
  void initState() {
    super.initState();
    _fetchUser(); // Fetch user info on init
    _fetchTickets(); // Fetch tickets on init
  }

  Future<void> _fetchUser() async {
    try {
      final userInfo = await _authService.fetchUser();
      setState(() {
        tenantId = userInfo['user']['id'];
        propertyId = userInfo['user']['property_id'];
      });
      print('Fetched user info: Tenant ID - $tenantId, Property ID - $propertyId');
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
      print('Successfully fetched tickets: ${tickets.length} tickets retrieved.');
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
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Use pickImage

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _raiseTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This allows the bottom sheet to adjust its height based on the keyboard
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // Adds padding to avoid keyboard overlap
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
                  if (_image != null) // Display the selected image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(
                        _image!,
                        height: 100,
                      ),
                    ),
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
                            _image, // Ensure this is defined to accept the image
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
    return Card(
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
