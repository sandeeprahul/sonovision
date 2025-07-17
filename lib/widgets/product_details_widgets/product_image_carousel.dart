import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../full_screen_image.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final String productId;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.productId,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _indicatorAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _goToNextPage();
        }
      });

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_animationController.isAnimating) {
        _goToNextPage();
      }
    });
  }

  void _goToNextPage() {
    _animationController.reset();
    _currentImageIndex = (_currentImageIndex + 1) % widget.images.length;
    _pageController.animateToPage(
      _currentImageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ).then((_) {
      _animationController.forward();
    });
  }

  void _pauseAutoSlide() {
    _animationController.stop();
    _timer?.cancel();
  }

  void _resumeAutoSlide() {
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_animationController.isAnimating) {
        _goToNextPage();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pauseAutoSlide(),
      onTapUp: (_) => _resumeAutoSlide(),
      onTapCancel: _resumeAutoSlide,
      onPanDown: (_) => _pauseAutoSlide(),
      onPanCancel: _resumeAutoSlide,
      onPanEnd: (_) => _resumeAutoSlide(),
      child: Stack(
        children: [
          // Your existing image carousel content
          Container(
            height: 360,
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                      _animationController.reset();
                      _animationController.forward();
                    });
                  },
                  itemBuilder: (context, index) {
                    final image = widget.images[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                              imageUrl: image,
                              heroTag: 'product-${widget.productId}-$image', // Optional hero tag
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'product-${widget.productId}-$image',
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 50),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Corrected Page Indicator with Smooth Animation
          if (widget.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length,
                      (index) {
                    final isActive = _currentImageIndex == index;
                    return Container(
                      width: 16, // Total container width for each indicator
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          if (isActive)
                            AnimatedBuilder(
                              animation: _indicatorAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 16 * _indicatorAnimation.value,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
/*
class ProductImageCarouselff extends StatefulWidget {
  final List<String> images;
  final String productId;

  const ProductImageCarouselff({
    super.key,
    required this.images,
    required this.productId,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          margin: const EdgeInsets.all(12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentImageIndex = index);
                },
                itemBuilder: (context, index) {
                  final image = widget.images[index];
                  return Hero(
                    tag: 'product-${widget.productId}-$image',
                    child: CachedNetworkImage(
                      imageUrl: image,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentImageIndex == index ? 12 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}*/
