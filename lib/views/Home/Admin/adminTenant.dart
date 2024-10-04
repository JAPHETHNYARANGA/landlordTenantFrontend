import 'package:flutter/material.dart';
import 'package:landlord_tenant/utils/urlContants.dart';
import '../../../Services/propertiesService.dart';
import '../../../Services/tenantService.dart';
import '../../../widgets/bottomNavigationBar.dart'; // Import your custom bottom navigation bar

class AdminTenantScreen extends StatefulWidget {
  const AdminTenantScreen({super.key});

  @override
  _AdminTenantScreenState createState() => _AdminTenantScreenState();
}

class _AdminTenantScreenState extends State<AdminTenantScreen> {
  int _selectedIndex = 0;
  final TenantService _tenantService = TenantService(base_url); // Replace with your actual API URL
  final PropertyService _propertyService = PropertyService(); // Property service
  List<Tenant> _tenants = [];
  List<dynamic> _properties = []; // List to store properties
  bool _isLoading = true; // Loading state for tenant list
  bool _isCreating = false; // Loading state for tenant creation

  @override
  void initState() {
    super.initState();
    _fetchTenants();
    _fetchProperties(); // Fetch properties on init
  }

  Future<void> _fetchTenants() async {
    try {
      final tenants = await _tenantService.fetchTenants();
      setState(() {
        _tenants = tenants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProperties() async {
    try {
      final properties = await _propertyService.getProperties();
      setState(() {
        _properties = properties; // Store fetched properties
      });
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  void _showAddTenantDialog() {
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _emailController = TextEditingController();
    final _addressController = TextEditingController();
    final _houseNoController = TextEditingController();
    int? _selectedPropertyId; // Variable to hold selected property ID

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Tenant'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _houseNoController,
                  decoration: InputDecoration(
                    labelText: 'House Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: _selectedPropertyId,
                  items: _properties.map((property) {
                    return DropdownMenuItem<int>(
                      value: property['id'], // Adjust based on your property structure
                      child: Text(property['name']), // Display property name
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Property',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedPropertyId = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: _isCreating
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Add'),
              onPressed: _isCreating
                  ? null
                  : () async {
                if (_selectedPropertyId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a property.')),
                  );
                  return; // Exit the function early
                }

                final newTenant = Tenant(
                  id: 0, // The ID will be generated by the server
                  name: _nameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                  address: _addressController.text,
                  houseNo: _houseNoController.text,
                  propertyId: _selectedPropertyId!, // Ensure it is non-null
                );

                setState(() {
                  _isCreating = true; // Start loading
                });

                try {
                  await _tenantService.createTenant(newTenant);
                  Navigator.of(context).pop(); // Close the dialog
                  _fetchTenants(); // Refresh the list
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add tenant: $e')),
                  );
                } finally {
                  setState(() {
                    _isCreating = false; // Stop loading
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTenant(int id) async {
    try {
      await _tenantService.deleteTenant(id);
      setState(() {
        _tenants.removeWhere((tenant) => tenant.id == id);
      });
    } catch (e) {
      // Handle error
    }
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this tenant?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () async {
                await _deleteTenant(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTenantDetailsDialog(Tenant tenant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tenant Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${tenant.name}'),
                SizedBox(height: 10),
                Text('Email: ${tenant.email}'),
                SizedBox(height: 10),
                Text('Phone: ${tenant.phoneNumber}'),
                SizedBox(height: 10),
                Text('Address: ${tenant.address}'),
                SizedBox(height: 10),
                Text('House No: ${tenant.houseNo}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
        title: Text('Manage Tenants', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('ADMIN', style: TextStyle(color: Colors.black)),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _showAddTenantDialog, // Show dialog to add tenant
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('+ Add Tenant'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _tenants.length,
                itemBuilder: (context, index) {
                  final tenant = _tenants[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.person), // Added icon here
                        title: Text(tenant.name), // Tenant name
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tenant.email), // Email
                            Text(tenant.phoneNumber), // Phone number
                          ],
                        ),
                        onTap: () => _showTenantDetailsDialog(tenant), // Show details on tap
                        trailing: IconButton(
                          icon: Icon(Icons.delete), // Delete icon
                          onPressed: () => _showDeleteConfirmationDialog(tenant.id),
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
