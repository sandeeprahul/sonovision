import 'package:electronic_store/utils/background_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BackgroundContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16,),
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              width: double.infinity,
              height: 180,
              child: Obx(() {
                final user = AuthController.to.user;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${user['name'] ?? 'Guest'}",
                      style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${user['email'] ?? 'Not set'}",
                      style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                  ],
                );
                return const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                );
              }),
            ),

            // _buildProfileItem(Icons.person_outline, 'Edit Profile','/edit-profile'),

            Column(
              children: [
                _buildProfileItem(
                    Icons.shopping_bag_outlined, 'My Orders', '/order-history'),
                _buildProfileItem(
                    Icons.location_on_outlined, 'Shipping Address', '/my-address'),
                // _buildProfileItem(Icons.payment_outlined, 'Payment Methods',''),
                _buildProfileItem(Icons.settings_outlined, 'Settings', '/settings'),
                _buildProfileItem(
                    Icons.help_outline, 'Help & Support', '/helpsupport'),
              ],
            ),


            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(

                onPressed: () {
                // AuthController.to.logout();
                _showLogoutConfirmation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Out'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout?'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {

              // final controller = Get.put(CheckoutController());
              AuthController.to.logout();

              // Navigator.pop(context);
              // Navigator.pop(context);


            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String routeName) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 2),
      decoration: BoxDecoration(
          // color: Colors.white,
          color: Colors.white.withAlpha(90),

          borderRadius: BorderRadius.circular(16)
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Get.toNamed(routeName),
      ),
    );
  }
}
//                  Navigator.pushNamed(context, '/order-history');
