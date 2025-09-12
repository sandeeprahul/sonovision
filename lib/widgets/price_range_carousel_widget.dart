import 'dart:async';
import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';

import '../models/product_of_brands.dart';
import '../pages/category_details_page.dart';
import '../pages/products_from_brand_category_screen.dart';

// Helper function to chunk list
List<List<T>> chunkList<T>(List<T> list, int size) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += size) {
    chunks.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }
  return chunks;
}

class PriceRangeCarousel extends StatefulWidget {///
  final List<PriceRange> priceRanges; // your model
  final Category category; // your model
  final Brand brand; // your model

  const PriceRangeCarousel({super.key, required this.priceRanges, required this. category,required this.brand});

  @override
  State<PriceRangeCarousel> createState() => _PriceRangeCarouselState();
}

class _PriceRangeCarouselState extends State<PriceRangeCarousel> {
  late final PageController _pageController;
  late final List<List<PriceRange>> _pages;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pages = chunkList(widget.priceRanges, 4);

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        itemBuilder: (context, pageIndex) {
          final currentChunk = _pages[pageIndex];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 2 columns
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 2,
              ),
              itemCount: currentChunk.length,
              itemBuilder: (context, index) {
                final range = currentChunk[index];

                final value = num.tryParse(range.max.toString());
                final formattedSubtitle = value != null
                    ? value.toINR()
                    : range.max.toString();

                return InkWell(
                  onTap: (){
                    print("range.id");
                    print(range.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsFromBrandCategoryScreen(
                          categoryId: widget.category.id,
                          categoryName:widget. category.name,
                          imageUrl:  "http://sonovision.asquare.org.in/images/${widget.category.icon}",
                /*          priceRangeMin: '${range.min}',
                          priceRangeMax: '${range.max}',*/
                          selectedRange: range, // send selected range

                        priceRanges: widget.category.priceRanges, // send full list
                          // filterId: range.id,
                          // filterTitle: "Price",
                          brandId: widget.brand.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    child: Center(
                      child: Text(
                        formattedSubtitle,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  )/*Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        formattedSubtitle,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ),*/
                );
              },
            ),
          );
        },
      ),
    );
  }
}
