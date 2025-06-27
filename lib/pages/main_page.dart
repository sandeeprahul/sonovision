import 'package:electronic_store/pages/login_page.dart';
import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/search_page.dart';
import '../services/auth_service.dart';
import '../utils/version_alert.dart';
import '../widgets/animated_bottom_bar.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import '../screens/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin,WidgetsBindingObserver {
  int _selectedIndex = 0;
  late final TabController _tabController;
  final List<Widget> _pages = [
    const HomeScreenTwo(),
     CartPage(),


     // SearchPage(),
    // const WishlistPage(),
    const ProfilePage(),
  ];
  DateTime? _lastBackPressTime;

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
  Future<bool> _handleExit() async {
    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable default back navigation
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        final shouldPop = await _handleExit();
        if (shouldPop && mounted) {
          Navigator.of(context).pop();
        }
      },      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: AnimatedBottomBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
  void _onItemSelected(int index) async {


    setState(() => _selectedIndex = index);

    if(_selectedIndex==3){
      final authController = Get.put(AuthController());
      final token = await authController.loadUserAndToken();
      String? email = authController.user['email'];
      String tokenValue = authController.token.value;
      bool loggedIn = authController.isLoggedIn;
      print(email);
      print(tokenValue);
      print(loggedIn);
      if (tokenValue.isEmpty) {
        Get.to(const LoginPage());
      }else{
        _tabController.animateTo(index);
      }
      return;
    }
    _tabController.animateTo(index);
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedIndex = _tabController.index);
      }
    });
  }

}
