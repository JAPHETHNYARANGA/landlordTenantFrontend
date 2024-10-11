import 'package:flutter/material.dart';
import 'package:landlord_tenant/utils/urlContants.dart';
import '../../../Services/propertiesService.dart';
import '../../../Services/landlordService.dart'; // Import your landlord service
import '../../../widgets/bottomNavigationBar.dart'; // Import your custom bottom navigation bar

class LandlordPropertiesScreen extends StatefulWidget {
  const LandlordPropertiesScreen({Key? key}) : super(key: key);


  @override
  _LandlordPropertiesScreenState createState() => _LandlordPropertiesScreenState();
}

class _LandlordPropertiesScreenState extends State<LandlordPropertiesScreen> {
  int _selectedIndex = 0;
  final PropertyService _propertyService = PropertyService();
  final LandlordService _landlordService = LandlordService(base_url); // Replace with your actual base URL
  List<dynamic> _properties = [];
  List<Landlord> _landlords = [];
  String? _selectedStatus;
  int? _selectedLandlordId;
  bool _isLoading = true;

  final List<String> _statuses = ['Available', 'Unavailable', 'Pending']; // Add more statuses as needed

  @override
  void initState() {
    super.initState();
    _loadProperties();
    _loadLandlords();
  }

  Future<void> _loadProperties() async {
    try {
      final properties = await _propertyService.getLandlordProperties();
      setState(() {
        _properties = properties;
      });
    } catch (e) {
      print('Error loading properties: $e');
    }
  }

  Future<void> _loadLandlords() async {
    try {
      final landlords = await _landlordService.fetchLandlords();

      setState(() {
        _landlords = landlords;
        _isLoading = false;
      });
      // Log fetched landlords
      print('Fetched landlords: $_landlords');
    } catch (e) {
      print('Error loading landlords: $e');
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

  void _showAddPropertyDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _locationController = TextEditingController();
    final _roomsController = TextEditingController();
    final _priceController = TextEditingController();
    final _typeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Property'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter property name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter property location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _roomsController,
                    decoration: InputDecoration(
                      labelText: 'Number of Rooms',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of rooms';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter property price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter property type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    items: _statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a status';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: _selectedLandlordId,
                    items: _landlords.map((Landlord landlord) {
                      return DropdownMenuItem<int>(
                        value: landlord.id,
                        child: Text(landlord.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Landlord',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedLandlordId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a landlord';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
              child: Text('Add Property'),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final newProperty = {
                    'name': _nameController.text,
                    'location': _locationController.text,
                    'rooms': _roomsController.text,
                    'price': _priceController.text,
                    'type': _typeController.text,
                    'status': _selectedStatus,
                    'landlord_id': _selectedLandlordId,
                  };
                  try {
                    await _propertyService.addProperty(newProperty);
                    _loadProperties(); // Refresh the property list
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add property: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProperty(String id) async {
    try {
      await _propertyService.deleteProperty(id);
      _loadProperties(); // Refresh the property list
    } catch (e) {
      print('Failed to delete property: $e');
    }
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this property?'),
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
                await _deleteProperty(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPropertyDetailsDialog(Map<String, dynamic> property) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Property Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${property['name']}'),
                SizedBox(height: 10),
                Text('Location: ${property['location']}'),
                SizedBox(height: 10),
                Text('Number of Rooms: ${property['rooms']}'),
                SizedBox(height: 10),
                Text('Price: ${property['price']}'),
                SizedBox(height: 10),
                Text('Type: ${property['type']}'),
                SizedBox(height: 10),
                Text('Status: ${property['status']}'),
                SizedBox(height: 10),
                Text('Landlord ID: ${property['landlord_id']}'), // Display landlord ID
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Properties', style: TextStyle(color: Colors.black)),
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
                  onPressed: _showAddPropertyDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('+ Add Property'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, index) {
                  final property = _properties[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(property['name']),
                            ),
                            Expanded(
                              child: Text(property['location']),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _showPropertyDetailsDialog(property);
                                  },
                                  child: Text('Details'),
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () => _showDeleteConfirmationDialog(property['id']),
                                ),
                              ],
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
