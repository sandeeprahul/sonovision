import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Profile',style: TextStyle(color: Colors.white),),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.black87,
                    ],
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(//

          delegate: SliverChildListDelegate([
              // _buildProfileItem(Icons.person_outline, 'Edit Profile','/edit-profile'),
              _buildProfileItem(Icons.shopping_bag_outlined, 'My Orders','/order-history'),
              _buildProfileItem(Icons.location_on_outlined, 'Shipping Address','/my-address'),
              // _buildProfileItem(Icons.payment_outlined, 'Payment Methods',''),
              _buildProfileItem(Icons.settings_outlined, 'Settings','/settings'),
              _buildProfileItem(Icons.help_outline, 'Help & Support','/helpsupport'),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Get.toNamed(routeName),
    );
  }
}
//                  Navigator.pushNamed(context, '/order-history');
