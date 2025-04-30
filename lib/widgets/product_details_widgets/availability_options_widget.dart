import 'package:flutter/material.dart';

class AvailabilityOptions extends StatelessWidget {
  const AvailabilityOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      /*  boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],*/
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nearby Stores
          Container(height: 1,color: Colors.black38,width: 100,),
          Row(
            children: [
              Icon(Icons.store_mall_directory, color: Colors.black),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Available in 40+ stores near you",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Delivery Options
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: Colors.black),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Home Delivery or In-store Pickup options available",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
