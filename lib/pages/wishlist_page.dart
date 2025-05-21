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

    );
  }
}
