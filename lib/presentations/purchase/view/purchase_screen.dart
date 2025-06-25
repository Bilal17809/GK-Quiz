import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/purchase_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';


final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'gk.removeads.lifetime';
const String _kGoldSubscriptionId = 'gk.removeads.yearly';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (Object error) {
        // Handle errors here
      },
    );
    initStoreInfo();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseController());
    final mobileHeight = MediaQuery.of(context).size.height;
    final mobileWidth = MediaQuery.of(context).size.width;

    // Dynamic features data with image paths
    final features = [
      {'imagePath': 'assets/images/online-payment.png'},
      {'imagePath': 'assets/images/book.png'},
      {'imagePath': 'assets/images/science.png'},
    ];

    final purchaseFeature = [
      {'title': 'Smart AI', 'subtitle': 'Ask AI everything'},
      {'title': 'No Ads', 'subtitle': '100% ad free\nexperience'},
      {'title': 'Premium', 'subtitle': 'Access all features'},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [kSkyBlueColor, kWhite],
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 48),
                // Illustrations
                Container(
                  height: mobileHeight * 0.15,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: mobileHeight * 0.015),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.6,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items:
                    features.map((feature) {
                      return Image.asset(
                        feature['imagePath'] as String,
                        fit: BoxFit.contain,
                      );
                    }).toList(),
                  ),
                ),
                // Title and subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
                  child: Column(
                    children: [
                      Text(
                        'Upgrade to Premium & Get',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: kSkyBlueColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unlimited Access',
                        style: context.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                // Features carousel
                SizedBox(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: mobileHeight * 0.15,
                      viewportFraction: 0.75,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items:
                    purchaseFeature.map((purchaseFeature) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: mobileWidth * 0.08,
                        ),
                        decoration: roundedSkyBlueBorderDecoration,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: roundedDecoration,
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                purchaseFeature['title'] == 'No Ads'
                                    ? Icons.block
                                    : purchaseFeature['title'] == 'Smart AI'
                                    ? Icons.psychology
                                    : Icons.info_outline,
                                color:
                                purchaseFeature['title'] == 'No Ads'
                                    ? kRed
                                    : kBlack,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  purchaseFeature['title'] as String,
                                  style: context.textTheme.titleSmall,
                                ),
                                SizedBox(height: 2),
                                Text(
                                  purchaseFeature['subtitle'] as String,
                                  style: context.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height:16),
                _buildProductList(),
                // Plans
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     cacheExtent: 0,
                //     padding: EdgeInsets.zero,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemCount: 2,
                //     itemBuilder: (context, index) {
                //       return Obx(() {
                //         bool isSelected =
                //             controller.selectedPlanIndex.value == index;
                //         return Card(
                //           margin: kCardMargin,
                //           color: isSelected ? kSkyBlueColor : kWhite,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(14),
                //           ),
                //           elevation: 2,
                //           child: ListTile(
                //             onTap: () => controller.selectPlan(index),
                //             title: Text(
                //               index == 0 ? 'Monthly Plan' : 'Yearly Plan',
                //               style: context.textTheme.titleSmall?.copyWith(
                //                 color: isSelected ? kWhite : kBlack,
                //               ),
                //             ),
                //             subtitle: Text(
                //               '3 Days Free Trial',
                //               style: context.textTheme.bodySmall?.copyWith(
                //                 color:
                //                     isSelected
                //                         ? kWhite.withValues(alpha: 0.7)
                //                         : greyColor,
                //               ),
                //             ),
                //             trailing: Text(
                //               index == 0 ? 'Rs 1,000.00' : 'Rs 2,000.00',
                //               style: context.textTheme.titleSmall?.copyWith(
                //                 color: isSelected ? kWhite : kBlack,
                //               ),
                //             ),
                //           ),
                //         );
                //       });
                //     },
                //   ),
                // ),
                SizedBox(height: 8),
                // Cancel info
                Text(
                  '>> Cancel anytime atleast 24 hours before renewal',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: kSkyBlueColor,
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          // Close button
          Positioned(
            top: 0,
            right: mobileWidth * 0.04,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: mobileHeight * 0.02),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(mobileWidth * 0.02),
                    decoration: BoxDecoration(
                      color: kWhite.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kBlack.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: mobileWidth * 0.06,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildProductList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final PurchaseController purchaseController=Get.put(PurchaseController());

    double horizontalPadding = screenWidth * 0.04;
    double verticalPadding = screenHeight * 0.01;

    final Map<String, PurchaseDetails> purchases = {
      for (var purchase in _purchases) purchase.productID: purchase
    };

    return Column(
      children: List.generate(_products.length, (index) {
        final product = _products[index];
        final purchase = purchases[product.id];
        final isSelected = purchaseController.selectedPlanIndex.value == index; // Use RxInt in controller

        final double priceValue = double.tryParse(product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        final actualPrice = (priceValue * 2).toStringAsFixed(2);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: verticalPadding),
                color: isSelected ? kSkyBlueColor : kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
                child: ListTile(
                  onTap: () {
                    purchaseController.selectedPlanIndex.value = index;
                    _buyProduct(product, purchase);
                  },
                  title: Text(
                    product.id == _kSilverSubscriptionId
                        ? 'Life Time Subscription'
                        : '1 Year Subscription',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isSelected ? kWhite : kBlack,
                    ),
                  ),
                  subtitle: Text(
                    product.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isSelected ? kWhite.withOpacity(0.7) : greyColor,
                    ),
                  ),
                  trailing: product.id == _kSilverSubscriptionId
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rs $actualPrice",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? kWhite : Colors.red,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.price,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isSelected ? kWhite : kBlack,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    product.price,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isSelected ? kWhite : kBlack,
                    ),
                  ),
                ),
              ),
              if (product.id == _kSilverSubscriptionId)
                Positioned(
                  top: -5,
                  right: 10,
                  child: Image.asset(
                    'assets/images/discount.png',
                    width: 35,
                    height: 42,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }



  Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
    final purchaseParam = GooglePlayPurchaseParam(
      productDetails: product,
      changeSubscriptionParam: purchase != null
          ? ChangeSubscriptionParam(
        oldPurchaseDetails: purchase as GooglePlayPurchaseDetails,
      )
          : null,
    );

    if (product.id == _kConsumableId) {
      await _inAppPurchase.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: _kAutoConsume,
      );
    } else {
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> detailsList) async {
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else if (details.status == PurchaseStatus.error) {
        setState(() => _purchasePending = false);
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        setState(() => _purchasePending = false);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('SubscribedGk', true);
        await prefs.setString('subscriptionId', details.productID);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription purchased successfully!')),
        );
      }
    }
  }
}
