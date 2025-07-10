import 'package:electronic_store/services/auth_service.dart';
import 'package:electronic_store/utils/background_container_gradient.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/*class PremiumProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header with user stats
          SliverAppBar(
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: _UserStatsHeader(),
            ),
          ),

          // Dashboard metrics
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildListDelegate([
                _MetricCard(
                  icon: Icons.shopping_bag,
                  value: "12",
                  label: "Orders",
                  color: Colors.blue,
                  onTap: () => Get.toNamed('/orders'),
                ),
                _MetricCard(
                  icon: Icons.favorite,
                  value: "8",
                  label: "Wishlist",
                  color: Colors.pink,
                  onTap: () => Get.toNamed('/wishlist'),
                ),
                _MetricCard(
                  icon: Icons.star,
                  value: "Gold",
                  label: "Tier",
                  color: Colors.amber,
                  onTap: () => Get.toNamed('/rewards'),
                ),
                _MetricCard(
                  icon: Icons.location_on_outlined,
                  value: "3",
                  label: "My Address",
                  color: Colors.purple,
                  onTap: () => Get.toNamed('/my-address'),
                ),
              ]),
            ),
          ),

          // Quick actions section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text("Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildListDelegate([
                _ActionButton(
                  icon: Icons.settings,
                  label: "Settings",
                  onTap: () => Get.toNamed('/settings'),
                ),
                _ActionButton(
                  icon: Icons.support_agent,
                  label: "Support",
                  onTap: () => Get.toNamed('/support'),
                ),
                _ActionButton(
                  icon: Icons.privacy_tip,
                  label: "Privacy",
                  onTap: () => Get.toNamed('/privacy'),
                ),
                _ActionButton(
                  icon: Icons.card_giftcard,
                  label: "Offers",
                  onTap: () => Get.toNamed('/rewards'),
                ),
                _ActionButton(
                  icon: Icons.history,
                  label: "History",
                  onTap: () => Get.toNamed('/history'),
                ),
                _ActionButton(
                  icon: Icons.logout,
                  label: "Sign Out",
                  onTap: _confirmLogout,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Sign Out?"),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            child: Text("CANCEL"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text("SIGN OUT", style: TextStyle(color: Colors.red)),
            onPressed: () => AuthController.to.logout(),
          ),
        ],
      ),
    );
  }
}

class _UserStatsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Color(0xFF2575FC)],
          // colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: Obx(() {
        final user = AuthController.to.user;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: user['photoUrl'] != null
                  ? ClipOval(child: Image.network(user['photoUrl'], fit: BoxFit.cover))
                  : Icon(Icons.person, size: 40, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              user['name'] ?? 'Guest User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              user['email'] ?? 'email@example.com',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(value: "12", label: "Orders"),
                _StatItem(value: "₹8,420", label: "Spent"),
                _StatItem(value: "Gold", label: "Tier"),
              ],
            ),
            SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(height: 12),
              Text(value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.blue),
              SizedBox(height: 8),
              Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

class PremiumProfilePage extends StatefulWidget {
  @override
  _PremiumProfilePageState createState() => _PremiumProfilePageState();
}

class _PremiumProfilePageState extends State<PremiumProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BackgroundContainerGradient(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Obx(() {
                final user = AuthController.to.user;
                return Column(
                  children: [
                    const SizedBox(
                      height: 52,
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Obx(() {
                        final user = AuthController.to.user;
                        return CircleAvatar(
                          radius: 56,
                          backgroundColor: Colors.grey[200],
                          child: user['photoUrl'] != null
                              ? ClipOval(
                                  child: Image.network(
                                    user['photoUrl'],
                                    fit: BoxFit.cover,
                                    width: 112,
                                    height: 112,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                        );
                      }),
                    ),
                    Text(
                      user['name'] ?? 'Guest User',
                      style: const TextStyle(
                        fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    // const SizedBox(height: 8),
                    Text(
                      user['email'] ?? 'email@example.com',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 24),
                  ],
                );
              }),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileCard(
                  title: 'Account Settings',
                  children: [
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      route: '/edit-profile',
                    ),
                    _buildProfileItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notification Settings',
                      route: '/notification-settings',
                    ),
                  ],
                ),
                _buildProfileCard(
                  title: 'My Shopping',
                  children: [
                    _buildProfileItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      route: '/order-history',
                    ),
                    _buildProfileItem(
                      icon: Icons.door_front_door_outlined,
                      title: 'My Address',
                      route: '/my-address',
                    ),
                  ],
                ),
                _buildProfileCard(
                  title: 'Support',
                  children: [
                    _buildProfileItem(
                      icon: Icons.chat_outlined,
                      title: 'Contact Us',
                      route: '/contact-us',
                    ),

                    ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                    Icons.privacy_tip_outlined,
                            size: 20, color: Colors.grey[700]),
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                      onTap: (){
                        launchUrl(Uri.parse('http://sonovision.asquare.org.in/webpages/privacy-policy.html'), mode: LaunchMode.externalApplication);

                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      minLeadingWidth: 0,
                    ),

                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: _showLogoutConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'SIGN OUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      {required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[100]),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.grey[700]),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () => Get.toNamed(route),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 0,
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Sign Out',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AuthController.to.logout();
            },
            child: const Text('SIGN OUT', style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }
}

/* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Premium Member',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),*/

/* SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => Get.toNamed('/edit-profile'),
              ),
            ],
          ),*/
/*
SliverToBoxAdapter(
child: Transform.translate(
offset: Offset(0, 0),
child: Center(
child: Container(
width: 120,
height: 120,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: Colors.white,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 10,
spreadRadius: 2,
),
],
border: Border.all(
color: Colors.white,
width: 4,
),
),
child: Obx(() {
final user = AuthController.to.user;
return CircleAvatar(
radius: 56,
backgroundColor: Colors.grey[200],
child: user['photoUrl'] != null
? ClipOval(
child: Image.network(
user['photoUrl'],
fit: BoxFit.cover,
width: 112,
height: 112,
),
)
    : Icon(
Icons.person,
size: 48,
color: Colors.grey[600],
),
);
}),
),
),
),
),*/
