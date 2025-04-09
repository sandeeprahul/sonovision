import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildCategoryItem(
            icon: Icons.phone_android,
            label: 'Phones &\nTablets',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.laptop_mac,
            label: 'Laptops &\nPCs',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.headphones,
            label: 'Audio &\nSound',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.watch,
            label: 'Smart\nWatches',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.camera_alt,
            label: 'Cameras &\nDrones',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.videogame_asset,
            label: 'Gaming &\nConsoles',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.tv,
            label: 'TVs &\nDisplays',
            color: AppTheme.secondaryColor,
          ),
          _buildCategoryItem(
            icon: Icons.memory,
            label: 'PC Parts &\nAccessories',
            color: AppTheme.secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color.withOpacity(0.8),
                  size: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTheme.subtitleStyle.copyWith(
                  fontSize: 12,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 