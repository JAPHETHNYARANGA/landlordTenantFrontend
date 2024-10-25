import 'package:flutter/material.dart';
import '../../../Services/apartmentService.dart';
import '../../../widgets/bottomNavigationBar.dart';

class ApartmentDetailScreen extends StatefulWidget {
  final int apartmentId;

  ApartmentDetailScreen({required this.apartmentId}); // Accept apartment ID

  @override
  _ApartmentDetailScreenState createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  dynamic _apartment; // Variable to hold apartment details

  @override
  void initState() {
    super.initState();
    _fetchApartmentDetails(); // Fetch apartment details when the screen is initialized
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchApartmentDetails() async {
    try {
      final service = ApartmentService();
      final apartment = await service.getApartmentById(widget.apartmentId);
      setState(() {
        _apartment = apartment; // Update apartment details
        _isLoading = false; // Set loading to false
      });
    } catch (e) {
      print('Error fetching apartment details: $e');
      setState(() {
        _isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apartment Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              _apartment['image_url'], // Dynamic image URL
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _apartment['name'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      Text(_apartment['location']),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.king_bed, size: 16),
                      Text('${_apartment['bedrooms']} Br'),
                      SizedBox(width: 10),
                      Icon(Icons.bathtub, size: 16),
                      Text('${_apartment['bathrooms']} Bath'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'ksh ${_apartment['price']} /month',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _apartment['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                ],
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
