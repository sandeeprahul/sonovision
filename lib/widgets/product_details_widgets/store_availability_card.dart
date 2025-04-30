import 'package:flutter/material.dart';

  class StoreAvailabilityCard extends StatelessWidget {
  final int storeCount;
  final VoidCallback? onSeeLocations;
  final Widget? customMapPreview; // Optional custom map widget
  final Color accentColor;

  const StoreAvailabilityCard({
    super.key,
    required this.storeCount,
    this.onSeeLocations,
    this.customMapPreview,
    this.accentColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSeeLocations,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map Preview Section
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[100],
              ),
              child: customMapPreview ?? _buildDefaultMapPreview(),
            ),

            // Store Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available at $storeCount+ stores near you',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                      ),
                      if (onSeeLocations != null)
                        const Row(
                          children: [
                            Text(
                              'See locations',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildDistanceIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultMapPreview() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        child: Image.asset('assets/near_store_map.png', fit: BoxFit.cover,width: 400,));
  }

  Widget _buildDistanceIndicator() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Nearest store: ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),   Text(
              '1.2km away',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
     /*   const SizedBox(height: 4),
        LinearProgressIndicator(
          value: 0.4, // Example value - you'd use real distance data
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
          minHeight: 4,
        ),*/
      ],
    );
  }
}