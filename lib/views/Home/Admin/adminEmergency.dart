import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminEmergencyScreen extends StatefulWidget {
  const AdminEmergencyScreen({super.key});

  @override
  _AdminEmergencyScreenState createState() => _AdminEmergencyScreenState();
}

class _AdminEmergencyScreenState extends State<AdminEmergencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EMERGENCY',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Emergency Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  buildEmergencyButton(Icons.local_fire_department, 'FIRE'),
                  buildEmergencyButton(Icons.local_hospital, 'MEDICAL'),
                  buildEmergencyButton(Icons.local_police, 'POLICE'),
                  buildEmergencyButton(Icons.receipt, 'RESCUE'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Map Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  'Map Placeholder',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Report Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'REPORT',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmergencyButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () async {
        const url = 'tel:911';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to launch dialer.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            SizedBox(height: 10),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

}
