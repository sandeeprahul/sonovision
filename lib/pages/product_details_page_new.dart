import 'package:electronic_store/utils/background_container.dart';
import 'package:electronic_store/utils/background_container_gradient.dart';
import 'package:electronic_store/widgets/horizontal_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_details_controller.dart';
import '../models/product_details_data.dart';
import '../utils/cart_bottom_sheet.dart';
import '../widgets/product_details_widgets/FreedomSaleBanner.dart';
import '../widgets/product_details_widgets/count_down_timer_widget.dart';
import '../widgets/product_details_widgets/highlights_list.dart';
import '../widgets/product_details_widgets/price_display.dart';
import '../widgets/product_details_widgets/product_description.dart';
import '../widgets/product_details_widgets/product_header.dart';
import '../widgets/product_details_widgets/product_image_carousel.dart';
import '../widgets/product_details_widgets/review_section.dart';
import '../widgets/product_details_widgets/specifications_list.dart';
import '../widgets/product_details_widgets/store_availability_card.dart';
import '../widgets/product_details_widgets/store_availability_card_new.dart';

class ProductDetailsScreenNew extends StatefulWidget {
  const ProductDetailsScreenNew({
    super.key,
  });

  @override
  State<ProductDetailsScreenNew> createState() =>
      _ProductDetailsScreenNewState();
}

class _ProductDetailsScreenNewState extends State<ProductDetailsScreenNew> {
  late final Map<String, dynamic> product;

  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });*/
    // _scrollController.addListener(_onScroll);
    product = Get.arguments as Map<String, dynamic>;
  }

  final productDetailsController = Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    productDetailsController.fetchProduct(product['_id']);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration:  const BoxDecoration(        color: Colors.white,


          /*   gradient: LinearGradient(
                colors: [Colors.blue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)*/
        ),
        child: Obx(() {
          if (productDetailsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = productDetailsController.product.value;
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }

          final discountedPrice = product.price -
              (product.price * product.discountPercentage! / 100);

          final sale = product.sale;

          DateTime? saleEnd = sale?.endDate;

          if (saleEnd != null) {
            print('saleEnd Time: ${sale!.discountPercentage}');
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    height: 56,
                    child: Stack(
                      // fit: StackFit.loose,
                      // mainAxisAlignment: ,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.black,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Obx(() {
                            if (productDetailsController.isLoading.value) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                             // 'Details',
                              productDetailsController.product.value!.brand!.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  ProductImageCarousel(
                    images: product.images,
                    productId: product.id,
                  ),
                  const Divider(
                    thickness: 1,

                    color: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductHeader(
                          name: product.name,
                          brand: product.brand!.name,
                          averageRating:
                              productDetailsController.averageRating.value,
                          totalReviews:
                              productDetailsController.totalReviews.value,
                        ),
                        const SizedBox(height: 12),
                        if (sale != null)
                        PriceDisplay(
                          originalPrice: product.price,
                          discountedPrice: product.finalPrice!,
                          discountPercentage:
                              (product.sale!.discountPercentage!).toDouble(),
                        ),
                        if(product.discountPercentage!=0)
                          PriceDisplay(
                            originalPrice: product.price,
                            discountedPrice: discountedPrice,
                            discountPercentage:
                            (product.discountPercentage!).toDouble(),
                          ),
                        if(product.discountPercentage==0&&sale==null)
                          PriceDisplay(
                            originalPrice: product.price,
                            discountedPrice: discountedPrice,
                            discountPercentage:
                            (product.discountPercentage!).toDouble(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  if(sale!=null)
                    FreedomSaleBanner(
                      saleEndTime: saleEnd!,
                      // saleEndTime: DateTime.parse("2025-07-31 18:28:00Z"),
                      discountPercent: double.parse('${sale.discountPercentage}'),
                    ),
                  if(sale!=null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ProductDescription(description: product.description),
                  product.description.isEmpty? const SizedBox(): Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  // CountdownTimer(endTime: saleEnd!), // Only one timer


                  SpecificationsList(
                      specifications: product.specifications ?? {}),
                  HighlightsList(highlights: product.highlights),
                  product.highlights.isNotEmpty?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ):const SizedBox(),
                  ReviewSection(productId: product.id),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  StoreAvailabilityCard(
                    storeCount: 15,
                    onSeeLocations: () {
                      // openGoogleMapDirections();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Recently Brought',
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  HorizontalProductList(),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Future<void> openGoogleMapDirections(double destLat, double destLng) async {
    final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch directions.';
    }
  }


  Widget _buildBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Get.toNamed('/cart');
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: theme.primaryColor,
                  ),
                ),
              ),

              // Cart count badge
              Positioned(
                right: 4,
                top: 4,
                child: Obx(() {
                  final controller = Get.put(CartController());
                  return controller.cartItems.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints:
                              const BoxConstraints(minWidth: 20, minHeight: 20),
                          child: Text(
                            '${controller.cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final controller = Get.put(CartController());
                final product = productDetailsController.product.value!;

                final exists = controller.cartItems
                    .any((item) => item.productId == product.id);

                var discountedPrice = product.price -
                    (product.price * product.discountPercentage! / 100);

                if (product.sale!=null){
                  discountedPrice = product.finalPrice!;
                }

                if (exists) {
                  Get.snackbar(
                    'Info',
                    'Item already in cart',
                    overlayBlur: 2,
                    overlayColor: Colors.black26,
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(milliseconds: 1500),
                  );
                } else {
                  controller.addItem(CartItem(
                    name: product.name,
                    image: product.images[0],
                    color: 'Black',
                    price: discountedPrice,
                    productId: product.id,
                  ));
                  CartBottomSheet.show();
                }
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          /*Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
