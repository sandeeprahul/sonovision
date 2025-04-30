import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AnimatedBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.shopping_cart_rounded, 'Cart'),
          // _buildNavItem(2, Icons.search_rounded, 'Search'),
          _buildNavItem(2, Icons.favorite_rounded, 'Wishlist'),
          _buildNavItem(3, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String title) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: 0.0,
                  end: isSelected ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 1.0 + (value * 0.2),
                    child: Icon(
                      icon,
                      color: Color.lerp(
                        Colors.grey,
                        Colors.black,
                        value,
                      ),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: isSelected ? 20 : 0,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
