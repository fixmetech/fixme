import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/screens/Profile/customer_profile_account.dart';
import 'package:fixme/screens/Profile/customer_profile_history.dart';
import 'package:fixme/screens/Profile/customer_profile_home.dart';
import 'package:fixme/screens/Profile/customer_profile_security.dart';
import 'package:fixme/screens/Profile/customer_profile_support.dart';
import 'package:fixme/screens/Profile/customer_vehicle_profile.dart';
import 'package:fixme/screens/login_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    title: 'Customer Profile',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
    ),
    home: CustomerProfilePage(),
    routes: {
      '/home': (context) => CustomerHomeProfile(),
      '/vehicle': (context) => CustomerVehicleProfile(),
      '/history': (context) => CustomerProfileHistory(),
      '/support': (context) => CustomerProfileSupport(),
      '/account': (context) => CustomerProfileAccount(),
      '/security': (context) => CustomerProfileSecurity(),
    },
  ));
}

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  void _handleMenuTap(BuildContext context, String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _getPage(routeName)),
    );
  }

  Widget _getPage(String routeName) {
    switch (routeName) {
      case '/home':
        return CustomerHomeProfile();
      case '/vehicle':
        return CustomerVehicleProfile();
      case '/history':
        return CustomerProfileHistory();
      case '/support':
        return CustomerProfileSupport();
      case '/account':
        return CustomerProfileAccount();
      case '/security':
        return CustomerProfileSecurity();
      default:
        return CustomerProfilePage();
    }
  }

  void _handleLogout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Customer Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildContactCard(),
            _buildMenu(context),
            SizedBox(height: 20),
            _buildLogoutButton(context),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[800]!, Colors.blue[600]!],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage('https://wallpapers.com/images/hd/default-user-profile-icon-c8ljd88k8vow846e.png'),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Ishan Chamika',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Premium Customer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            _buildContactItem(
              Icons.email_outlined,
              'Email',
              'ishanchami@gmail.com',
              Colors.blue[600]!,
            ),
            SizedBox(height: 12),
            _buildContactItem(
              Icons.phone_outlined,
              'Phone',
              '+94 77 838 8456',
              Colors.green[600]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.home_outlined, 'Home Details', Colors.blue[600]!, '/home'),
          _buildDivider(),
          _buildMenuItem(context, Icons.directions_car_outlined, 'Vehicle Details', Colors.orange[600]!, '/vehicle'),
          _buildDivider(),
          _buildMenuItem(context, Icons.history_outlined, 'History', Colors.purple[600]!, '/history'),
          _buildDivider(),
          _buildMenuItem(context, Icons.support_agent_outlined, 'Support Center', Colors.green[600]!, '/support'),
          _buildDivider(),
          _buildMenuItem(context, Icons.account_circle_outlined, 'Account Settings', Colors.indigo[600]!, '/account'),
          _buildDivider(),
          _buildMenuItem(context, Icons.security_outlined, 'Security & Privacy', Colors.red[600]!, '/security'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color iconColor, String routeName) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: () => _handleMenuTap(context, routeName),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[100],
      indent: 60,
      endIndent: 20,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleLogout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[700],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[200]!),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_outlined),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
