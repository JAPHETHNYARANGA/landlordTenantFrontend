import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/apartmentService.dart';
import 'ApartmentDetailScreen.dart';
import 'modal/ApartmentFormModal.dart';
import '../../../widgets/bottomNavigationBar.dart';

class ApartmentListScreen extends StatefulWidget {
  @override
  _ApartmentListScreenState createState() => _ApartmentListScreenState();
}

class _ApartmentListScreenState extends State<ApartmentListScreen> {
  int _selectedIndex = 1;
  List<dynamic> _apartments = []; // List to hold apartments
  bool _isLoading = true; // Loading state
  bool _isAdmin = false; // Flag to check if the user is admin or superAdmin

  @override
  void initState() {
    super.initState();
    _fetchUserType(); // Fetch user type when the screen is initialized
    _fetchApartments(); // Fetch apartments
  }

  Future<void> _fetchUserType() async {
    final prefs = await SharedPreferences.getInstance();
    String userType = prefs.getString('userType') ?? '';
    setState(() {
      _isAdmin = userType == 'admin' || userType == 'superAdmin'; // Check user type
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to show the apartment form modal
  void _showAddApartmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ApartmentFormModal(
          onApartmentAdded: _fetchApartments, // Pass callback to refresh list
        );
      },
    );
  }

  Future<void> _fetchApartments() async {
    try {
      final service = ApartmentService();
      final apartments = await service.getApartments();
      setState(() {
        _apartments = apartments; // Update the apartment list
        _isLoading = false; // Set loading to false
      });
    } catch (e) {
      print('Error fetching apartments: $e');
      setState(() {
        _isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartments'),
        actions: [
          if (_isAdmin) // Show button only for admin or superAdmin
            ElevatedButton(
              onPressed: () {
                _showAddApartmentModal(context); // Show dialog to add apartment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('+ Add Apartment'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator
            : _apartments.isEmpty
            ? Center(child: Text('No apartments available.')) // Show message if no apartments
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _apartments.length,
                itemBuilder: (context, index) {
                  return apartmentCard(context, _apartments[index]);
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

  // Updated apartment card to display dynamic data
  Widget apartmentCard(BuildContext context, dynamic apartment) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentDetailScreen(apartmentId: apartment['id']),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              apartment['image_url'], // Dynamic image URL
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apartment['name'], // Dynamic apartment name
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      Text(apartment['location']), // Dynamic location
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.king_bed, size: 16),
                      Text('${apartment['bedrooms']} Br'), // Dynamic bedrooms
                      SizedBox(width: 10),
                      Icon(Icons.bathtub, size: 16),
                      Text('${apartment['bathrooms']} Bath'), // Dynamic bathrooms
                    ],
                  ),
                  Text(
                    'Ksh ${apartment['price']} /month', // Dynamic price
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
