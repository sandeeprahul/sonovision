import 'dart:async';
import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';

import '../models/product_of_brands.dart';
import '../pages/category_details_page.dart';

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

  const PriceRangeCarousel({super.key, required this.priceRanges, required this. category});

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
                childAspectRatio: 3.5,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailsPage(
                          categoryId: widget.category.id,
                          categoryName:widget. category.name,
                          imageUrl:  "http://sonovision.asquare.org.in/images/${widget.category.icon}",
                          priceRangeMin: '${range.min}',
                          priceRangeMax: '${range.max}',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        formattedSubtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
