import 'package:flutter/material.dart';

import '../widgets/horizontal_product_list.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        elevation: 0,
      ),
      body: HorizontalProductList(),
      // body: const Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Icon(
      //         Icons.heart_broken,
      //          size: 120,color: Colors.black,
      //       ),
      //       SizedBox(height: 16),
      //       Text(
      //         'Your wishlist is empty'
      //           ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
