import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Home/Admin/adminProperties.dart';
import 'package:landlord_tenant/views/Home/LandLord/landlordHome.dart';
import 'package:landlord_tenant/views/Home/LandLord/landlordProperties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Home/Admin/adminAccount.dart';
import '../views/Home/Admin/adminHome.dart';
import '../views/Home/Admin/adminLandlord.dart';
import '../views/Home/Admin/adminTenant.dart';
import '../views/Home/LandLord/LandlordAccounts.dart';
import '../views/Home/SharedPages/ApartmentListScreen.dart';
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
    onItemTapped(0); // Update selected index for Home tab

    switch (userType) {
      case 'admin':
      case 'superAdmin':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        break;
      case 'tenant':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantHome()));
        break;
      case 'landlord':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LandlordHome()));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantHome())); // Default to tenant home
        break;
    }
  }

  Future<void> _navigateToAccount(BuildContext context) async {
    final userType = await _getUserType();
    onItemTapped(3); // Update selected index for My Account tab

    switch (userType) {
      case 'superAdmin':
      case 'admin':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAccountScreen()));
        break;
      case 'tenant':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantAccountScreen()));
        break;
      case 'landlord':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LandlordAccountScreen()));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantAccountScreen())); // Default case
        break;
    }
  }

  void _navigateToTermsConditions(BuildContext context) {
    onItemTapped(2); // Update selected index for Terms & Conditions tab
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionsPage()));
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
          _buildNavItem(Icons.location_city, 'Properties', selectedIndex == 1, 1, context, (context) => Navigator.push(context, MaterialPageRoute(builder: (context) => ApartmentListScreen()))),

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
          _buildNavItem(Icons.description, 'Terms & Conditions', selectedIndex == 2, 2, context, _navigateToTermsConditions),
          _buildNavItem(Icons.person, 'My Account', selectedIndex == 3, 3, context, _navigateToAccount),
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
            color: isSelected ? Colors.blue : Colors.grey, // Change selected icon color
            onPressed: () {
              if (navigationCallback != null) {
                navigationCallback(context);
              } else {
                onItemTapped(index);
              }
            },
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey, // Change selected text color
              fontSize: 5, // Adjusted for better readability
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
