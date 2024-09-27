import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Home/Admin/adminHome.dart';
import '../views/Home/Admin/adminLandlord.dart';
import '../views/Home/Admin/adminTenant.dart';
import '../views/Home/Tenant/tenantHome.dart';
import '../views/Home/SharedPages/TermsConditions.dart';
import '../views/Home/Tenant/TenantAccount.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  Future<String> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType') ?? 'tenant'; // Assuming 'tenant' as default
  }

  void _navigateBasedOnUserType(BuildContext context) async {
    final userType = await _getUserType();

    switch (userType) {
      case 'admin':
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        break;
      case 'superAdmin':
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        break;
      case 'tenant':
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TenantHome()));
        break;
      case 'landlord':
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminLandlordScreen()));
        break;
      default:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TenantHome())); // Default to tenant home
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', selectedIndex == 0, 0, context, _navigateBasedOnUserType),
          _buildNavItem(Icons.location_city, 'Properties', selectedIndex == 1, 1, context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Image.asset(
                'assets/images/plain_logo.png',
                width: 60,
                height: 60,
              ),
              onPressed: () {}, // Typically no action
            ),
          ),
          _buildNavItem(Icons.description, 'Terms & Conditions', selectedIndex == 2, 2, context),
          _buildNavItem(Icons.person, 'My Account', selectedIndex == 3, 3, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, int index, BuildContext context, [Function(BuildContext)? navigationCallback]) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(icon),
            color: isSelected ? Colors.blue : Colors.grey,
            onPressed: () {
              if (navigationCallback != null && index == 0) {
                navigationCallback(context);
              } else if (index == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionsPage()));
              } else if (index == 3) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TenantAccountScreen()));
              } else {
                onItemTapped(index);
              }
            },
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
