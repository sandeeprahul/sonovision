import 'package:electronic_store/pages/login_page.dart';
import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../widgets/animated_bottom_bar.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final TabController _tabController;
  final List<Widget> _pages = [
    const HomeScreenTwo(),
     CartPage(),

    const WishlistPage(),
    const ProfilePage(),
  ];
///    // const SearchPage(),
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemSelected(int index) async {


    setState(() => _selectedIndex = index);

    if(_selectedIndex==3){
      final token = await AuthService().getToken();
      if (token == null || token.isEmpty) {
        Get.to(const LoginPage());
      }
      return;
    }
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: AnimatedBottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
