import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/Home/Admin/adminAccount.dart';
import '../views/Home/Admin/adminHome.dart';
import '../views/Home/Admin/adminLandlord.dart';
import '../views/Home/Admin/adminTenant.dart';
import '../views/Home/LandLord/LandlordAccounts.dart';
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

  void _navigateToAccount(BuildContext context) async {
    final userType = await _getUserType();

    switch (userType) {
      case 'superAdmin':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAccountScreen())); // Adjust to correct Admin Account page
        break;
      case 'admin':
        Navigator.push(context, MaterialPageRoute(builder: (context) => AdminAccountScreen())); // Adjust to correct Admin Account page
        break;
      case 'tenant':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantAccountScreen()));
        break;
      case 'landlord':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LandlordAccountScreen())); // Adjust to correct Landlord Account page
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TenantAccountScreen())); // Default case
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
            color: isSelected ? Colors.blue : Colors.grey,
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
