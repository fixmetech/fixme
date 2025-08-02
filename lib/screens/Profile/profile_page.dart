import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/screens/Profile/customer_profile_account.dart';
import 'package:fixme/screens/Profile/customer_profile_history.dart';
import 'package:fixme/screens/Profile/customer_profile_home.dart';
import 'package:fixme/screens/Profile/customer_profile_security.dart';
import 'package:fixme/screens/Profile/customer_profile_support.dart';
import 'package:fixme/screens/Profile/customer_vehicle_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixme/utils/constants/size.dart';

class CustomerProfilePage extends StatelessWidget {
  const CustomerProfilePage({super.key});

  void _handleMenuTap(Widget screen) {
    Get.to(screen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.blue[800],
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // Calculate collapse progress (0.0 = fully expanded, 1.0 = fully collapsed)
                final double appBarHeight = constraints.biggest.height;
                final double statusBarHeight = MediaQuery.of(
                  context,
                ).padding.top;
                final double minHeight = kToolbarHeight + statusBarHeight;
                final double maxHeight = 280.0 + statusBarHeight;
                final double collapseProgress =
                    ((maxHeight - appBarHeight) / (maxHeight - minHeight))
                        .clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 16,
                    bottom: 16,
                    right: collapseProgress > 0.5 ? 16 : 0,
                  ),
                  centerTitle: collapseProgress < 0.5,
                  title: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    child: collapseProgress > 0.5
                        ? Row(
                            mainAxisSize:
                                MainAxisSize.max, 
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: const AssetImage(
                                    'assets/images/car.png',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue[800]!, Colors.blue[600]!],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: 1.0 - collapseProgress,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
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
                              backgroundImage: const AssetImage(
                                'assets/images/car.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: 1.0 - collapseProgress,
                          child: const Text(
                            'Ishan Chamika',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildContactCard(),
                _buildMenu(),
                const SizedBox(height: FixMeSizes.defaultSpace),
                _buildLogoutButton(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
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
          const SizedBox(height: FixMeSizes.appBarHeight),
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: FixMeSizes.defaultSpace),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: const [
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
              backgroundImage: const AssetImage('assets/images/car.png'),
            ),
          ),
          const SizedBox(height: FixMeSizes.spaceBtwItems),
          const Text(
            'Ishan Chamika',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: FixMeSizes.spaceBtwItems),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.email_outlined,
              'Email',
              'ishanchami@gmail.com',
              Colors.blue[600]!,
            ),
            const SizedBox(height: 12),
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

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
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

  Widget _buildMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.home_outlined,
            'Home Details',
            Colors.blue[600]!,
            CustomerHomeProfile(),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.directions_car_outlined,
            'Vehicle Details',
            Colors.orange[600]!,
            CustomerVehicleProfile(),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.history_outlined,
            'History',
            Colors.purple[600]!,
            CustomerProfileHistory(),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.support_agent_outlined,
            'Support Center',
            Colors.green[600]!,
            CustomerProfileSupport(),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.account_circle_outlined,
            'Account Settings',
            Colors.indigo[600]!,
            CustomerProfileAccount(),
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.security_outlined,
            'Security & Privacy',
            Colors.red[600]!,
            CustomerProfileSecurity(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Color iconColor,
    Widget screen,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
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
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () => _handleMenuTap(screen),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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

  Widget _buildLogoutButton(context) {
    final controller = Get.put(SignupController());
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => controller.logout(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[200]!),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_outlined),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
