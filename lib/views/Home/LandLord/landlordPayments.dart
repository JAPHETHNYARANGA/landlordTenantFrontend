import 'package:flutter/material.dart';

import '../../../widgets/bottomNavigationBar.dart';

class LandlordPaymentScreen extends StatefulWidget {
  const LandlordPaymentScreen({Key? key}) : super(key: key);

  @override
  _LandlordPaymentScreenState createState() => _LandlordPaymentScreenState();
}

class _LandlordPaymentScreenState extends State<LandlordPaymentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedPaymentStatus = 'Paid'; // Default status
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Payments'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar and Update button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Update functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Column headers for Name, Location, and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),

            // Payment list (sample data)
            Expanded(
              child: ListView.builder(
                itemCount: 5, // For now, using static 5 items for the list
                itemBuilder: (context, index) {
                  return _buildPaymentRow('Lake View', 'Thika');
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

  // Widget to build each payment row
  Widget _buildPaymentRow(String name, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Property name
          Text(name),
          // Property location
          Text(location),
          // Actions (Payment status dropdown and delete icon)
          Row(
            children: [
              DropdownButton<String>(
                value: selectedPaymentStatus,
                items: <String>['Paid', 'Unpaid', 'Pending'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentStatus = newValue!;
                  });
                },
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Delete functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
