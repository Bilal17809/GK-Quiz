// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../controller/purchase_controller.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_styles.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
//
//
// final bool _kAutoConsume = Platform.isIOS || true;
//
// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'gk.removeads.lifetime';
// const String _kGoldSubscriptionId = 'gk.removeads.yearly';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
//   _kGoldSubscriptionId,
// ];
// class PurchaseScreen extends StatefulWidget {
//   const PurchaseScreen({super.key});
//
//   @override
//   State<PurchaseScreen> createState() => _PurchaseScreenState();
// }
//
// class _PurchaseScreenState extends State<PurchaseScreen> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = <String>[];
//   List<ProductDetails> _products = <ProductDetails>[];
//   List<PurchaseDetails> _purchases = <PurchaseDetails>[];
//   List<String> _consumables = <String>[];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   @override
//   void initState() {
//     super.initState();
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       _listenToPurchaseUpdated,
//       onDone: () => _subscription.cancel(),
//       onError: (Object error) {
//         // Handle errors here
//       },
//     );
//     initStoreInfo();
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         _purchases = [];
//         _notFoundIds = [];
//         _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }
//
//     final ProductDetailsResponse productDetailResponse =
//     await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = productDetailResponse.error!.message;
//         _isAvailable = isAvailable;
//         _loading = false;
//       });
//       return;
//     }
//
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _loading = false;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(PurchaseController());
//     final mobileHeight = MediaQuery.of(context).size.height;
//     final mobileWidth = MediaQuery.of(context).size.width;
//
//     // Dynamic features data with image paths
//     final features = [
//       {'imagePath': 'assets/images/online-payment.png'},
//       {'imagePath': 'assets/images/book.png'},
//       {'imagePath': 'assets/images/science.png'},
//     ];
//
//     final purchaseFeature = [
//       {'title': 'Smart AI', 'subtitle': 'Ask AI everything'},
//       {'title': 'No Ads', 'subtitle': '100% ad free\nexperience'},
//       {'title': 'Premium', 'subtitle': 'Access all features'},
//     ];
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background gradient
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.center,
//                 colors: [kSkyBlueColor, kWhite],
//               ),
//             ),
//           ),
//           // Main content
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: 48),
//                 // Illustrations
//                 Container(
//                   height: mobileHeight * 0.15,
//                   width: double.infinity,
//                   margin: EdgeInsets.symmetric(vertical: mobileHeight * 0.015),
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       viewportFraction: 0.6,
//                       enableInfiniteScroll: true,
//                       autoPlay: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                     ),
//                     items:
//                     features.map((feature) {
//                       return Image.asset(
//                         feature['imagePath'] as String,
//                         fit: BoxFit.contain,
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 // Title and subtitle
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
//                   child: Column(
//                     children: [
//                       Text(
//                         'Upgrade to Premium & Get',
//                         style: context.textTheme.titleMedium?.copyWith(
//                           color: kSkyBlueColor,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Unlimited Access',
//                         style: context.textTheme.titleLarge,
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 // Features carousel
//                 SizedBox(
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       height: mobileHeight * 0.15,
//                       viewportFraction: 0.75,
//                       enableInfiniteScroll: true,
//                       autoPlay: true,
//                       autoPlayInterval: const Duration(seconds: 3),
//                     ),
//                     items:
//                     purchaseFeature.map((purchaseFeature) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(
//                           horizontal: mobileWidth * 0.08,
//                         ),
//                         decoration: roundedSkyBlueBorderDecoration,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: roundedDecoration,
//                               padding: EdgeInsets.all(4),
//                               child: Icon(
//                                 purchaseFeature['title'] == 'No Ads'
//                                     ? Icons.block
//                                     : purchaseFeature['title'] == 'Smart AI'
//                                     ? Icons.psychology
//                                     : Icons.info_outline,
//                                 color:
//                                 purchaseFeature['title'] == 'No Ads'
//                                     ? kRed
//                                     : kBlack,
//                                 size: 18,
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   purchaseFeature['title'] as String,
//                                   style: context.textTheme.titleSmall,
//                                 ),
//                                 SizedBox(height: 2),
//                                 Text(
//                                   purchaseFeature['subtitle'] as String,
//                                   style: context.textTheme.bodySmall,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 SizedBox(height:16),
//                 _buildProductList(),
//                 // Plans
//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
//                 //   child: ListView.builder(
//                 //     shrinkWrap: true,
//                 //     cacheExtent: 0,
//                 //     padding: EdgeInsets.zero,
//                 //     physics: NeverScrollableScrollPhysics(),
//                 //     itemCount: 2,
//                 //     itemBuilder: (context, index) {
//                 //       return Obx(() {
//                 //         bool isSelected =
//                 //             controller.selectedPlanIndex.value == index;
//                 //         return Card(
//                 //           margin: kCardMargin,
//                 //           color: isSelected ? kSkyBlueColor : kWhite,
//                 //           shape: RoundedRectangleBorder(
//                 //             borderRadius: BorderRadius.circular(14),
//                 //           ),
//                 //           elevation: 2,
//                 //           child: ListTile(
//                 //             onTap: () => controller.selectPlan(index),
//                 //             title: Text(
//                 //               index == 0 ? 'Monthly Plan' : 'Yearly Plan',
//                 //               style: context.textTheme.titleSmall?.copyWith(
//                 //                 color: isSelected ? kWhite : kBlack,
//                 //               ),
//                 //             ),
//                 //             subtitle: Text(
//                 //               '3 Days Free Trial',
//                 //               style: context.textTheme.bodySmall?.copyWith(
//                 //                 color:
//                 //                     isSelected
//                 //                         ? kWhite.withValues(alpha: 0.7)
//                 //                         : greyColor,
//                 //               ),
//                 //             ),
//                 //             trailing: Text(
//                 //               index == 0 ? 'Rs 1,000.00' : 'Rs 2,000.00',
//                 //               style: context.textTheme.titleSmall?.copyWith(
//                 //                 color: isSelected ? kWhite : kBlack,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         );
//                 //       });
//                 //     },
//                 //   ),
//                 // ),
//                 SizedBox(height: 8),
//                 // Cancel info
//                 Text(
//                   '>> Cancel anytime atleast 24 hours before renewal',
//                   style: context.textTheme.bodySmall?.copyWith(
//                     color: kSkyBlueColor,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//               ],
//             ),
//           ),
//           // Close button
//           Positioned(
//             top: 0,
//             right: mobileWidth * 0.04,
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(top: mobileHeight * 0.02),
//                 child: GestureDetector(
//                   onTap: () => Get.back(),
//                   child: Container(
//                     padding: EdgeInsets.all(mobileWidth * 0.02),
//                     decoration: BoxDecoration(
//                       color: kWhite.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: kBlack.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: mobileWidth * 0.06,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Column _buildProductList() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final PurchaseController purchaseController=Get.put(PurchaseController());
//
//     double horizontalPadding = screenWidth * 0.04;
//     double verticalPadding = screenHeight * 0.01;
//
//     final Map<String, PurchaseDetails> purchases = {
//       for (var purchase in _purchases) purchase.productID: purchase
//     };
//
//     return Column(
//       children: List.generate(_products.length, (index) {
//         final product = _products[index];
//         final purchase = purchases[product.id];
//         final isSelected = purchaseController.selectedPlanIndex.value == index; // Use RxInt in controller
//
//         final double priceValue = double.tryParse(product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
//         final actualPrice = (priceValue * 2).toStringAsFixed(2);
//
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//           child: Stack(
//             children: [
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: verticalPadding),
//                 color: isSelected ? kSkyBlueColor : kWhite,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 elevation: 2,
//                 child: ListTile(
//                   onTap: () {
//                     purchaseController.selectedPlanIndex.value = index;
//                     _buyProduct(product, purchase);
//                   },
//                   title: Text(
//                     product.id == _kSilverSubscriptionId
//                         ? 'Life Time Subscription'
//                         : '1 Year Subscription',
//                     style: context.textTheme.titleSmall?.copyWith(
//                       color: isSelected ? kWhite : kBlack,
//                     ),
//                   ),
//                   subtitle: Text(
//                     product.description,
//                     style: context.textTheme.bodySmall?.copyWith(
//                       color: isSelected ? kWhite.withOpacity(0.7) : greyColor,
//                     ),
//                   ),
//                   trailing: product.id == _kSilverSubscriptionId
//                       ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "Rs $actualPrice",
//                         style: TextStyle(
//                           decoration: TextDecoration.lineThrough,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: isSelected ? kWhite : Colors.red,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         product.price,
//                         style: context.textTheme.titleSmall?.copyWith(
//                           color: isSelected ? kWhite : kBlack,
//                         ),
//                       ),
//                     ],
//                   )
//                       : Text(
//                     product.price,
//                     style: context.textTheme.titleSmall?.copyWith(
//                       color: isSelected ? kWhite : kBlack,
//                     ),
//                   ),
//                 ),
//               ),
//               if (product.id == _kSilverSubscriptionId)
//                 Positioned(
//                   top: -5,
//                   right: 10,
//                   child: Image.asset(
//                     'assets/images/discount.png',
//                     width: 35,
//                     height: 42,
//                   ),
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//
//
//   Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
//     final purchaseParam = GooglePlayPurchaseParam(
//       productDetails: product,
//       changeSubscriptionParam: purchase != null
//           ? ChangeSubscriptionParam(
//         oldPurchaseDetails: purchase as GooglePlayPurchaseDetails,
//       )
//           : null,
//     );
//
//     if (product.id == _kConsumableId) {
//       await _inAppPurchase.buyConsumable(
//         purchaseParam: purchaseParam,
//         autoConsume: _kAutoConsume,
//       );
//     } else {
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     }
//   }
//
//   Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> detailsList) async {
//     for (var details in detailsList) {
//       if (details.status == PurchaseStatus.pending) {
//         setState(() => _purchasePending = true);
//       } else if (details.status == PurchaseStatus.error) {
//         setState(() => _purchasePending = false);
//       } else if (details.status == PurchaseStatus.purchased ||
//           details.status == PurchaseStatus.restored) {
//         setState(() => _purchasePending = false);
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('SubscribedGk', true);
//         await prefs.setString('subscriptionId', details.productID);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Subscription purchased successfully!')),
//         );
//       }
//     }
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/presentations/terms/view/terms.dart';
import '../../terms/view/unsubscribe_info.dart';
import '../controller/purchase_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

final bool _kAutoConsume = Platform.isIOS || true;

// Product IDs
const String _kIOSRemoveAdsId = 'com.gk.removeads';
const String _kAndroidConsumableId = 'consumable';
const String _kAndroidUpgradeId = 'upgrade';
const String _kAndroidLifetimeId = 'gk.removeads.lifetime';
const String _kAndroidYearlyId = 'gk.removeads.yearly';

List<String> get _productIds {
  if (Platform.isIOS) {
    return [_kIOSRemoveAdsId];
  } else {
    return [
      _kAndroidConsumableId,
      _kAndroidUpgradeId,
      _kAndroidLifetimeId,
      _kAndroidYearlyId,
    ];
  }
}

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
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(_listenToPurchaseUpdated);
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
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final ProductDetailsResponse response =
    await _inAppPurchase.queryProductDetails(_productIds.toSet());

    if (response.error != null) {
      setState(() {
        _queryProductError = response.error!.message;
        _isAvailable = isAvailable;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = response.productDetails;
      _notFoundIds = response.notFoundIDs;
      _loading = false;
    });
  }

  bool isLifetimeProduct(String id) {
    return id == _kAndroidLifetimeId || id == _kIOSRemoveAdsId;
  }

  Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
    final PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        changeSubscriptionParam: purchase != null
            ? ChangeSubscriptionParam(
          oldPurchaseDetails: purchase as GooglePlayPurchaseDetails,
        )
            : null,
      );
    } else {
      purchaseParam = PurchaseParam(productDetails: product);
    }

    if (product.id == _kAndroidConsumableId) {
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [kSkyBlueColor, kWhite],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height:height*0.1),
                Container(
                  height: height * 0.18,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: height * 0.015),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.6,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items: features.map((feature) {
                      return Image.asset(
                        feature['imagePath']!,
                        fit: BoxFit.contain,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    children: [
                      Text(
                        _hasActiveSubscription()
                            ? 'You are on Ads Free Version'
                            : 'Upgrade to Premium & Get',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: _hasActiveSubscription() ? Colors.green : kSkyBlueColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Text(
                      //   'Upgrade to Premium & Get',
                      //   style: context.textTheme.titleMedium?.copyWith(
                      //     color: kSkyBlueColor,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: 8),
                      Text(
                        'Unlimited Access',
                        style: context.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height:18),
                CarouselSlider(
                  options: CarouselOptions(
                    height: height * 0.15,
                    viewportFraction: 0.75,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  items: purchaseFeature.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.08),
                      decoration: roundedSkyBlueBorderDecoration,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: roundedDecoration,
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              item['title'] == 'No Ads'
                                  ? Icons.block
                                  : item['title'] == 'Smart AI'
                                  ? Icons.psychology
                                  : Icons.info_outline,
                              color: item['title'] == 'No Ads'
                                  ? kRed
                                  : kBlack,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item['title']!, style: context.textTheme.titleSmall),
                              SizedBox(height: 2),
                              Text(item['subtitle']!, style: context.textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height:height*0.03),
                _buildProductList(),
                SizedBox(height:3),
                Text(
                  '>> Cancel anytime at least 24 hours before renewal',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: kSkyBlueColor,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Terms & Conditions',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: blackTextColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        onTap:(){
                          Get.to(TermsScreen());
                        },
                      ),
                      GestureDetector(
                        onTap:(){
                          Get.to(UnsubscribeInfoScreen());
                        },
                        child: Text(
                          'How to Subscribe?',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: kSkyBlueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height:20),
                if(Platform.isIOS)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        onTap: _restorePurchases,
                        child: Container(
                          decoration: BoxDecoration(
                            color:Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _purchasePending
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                                SizedBox(width:6),
                                Text("Restoring...", style: TextStyle(color: Colors.white)),
                              ],
                            )
                                : Text(
                                  "Restore >>",
                                  style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:16,
                                color: Colors.white,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: width * 0.04,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.02),
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
                    child: Icon(Icons.close, color: Colors.white, size: width * 0.06),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _restorePurchases() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store is not available!')),
      );
      return;
    }

    setState(() {
      _purchasePending = true;
    });

    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds: 10), () {
        if (_purchasePending) {
          setState(() {
            _purchasePending = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Restore timed out. Please try again.')),
            );
          });
        }
      });

    } catch (e) {
      setState(() {
        _purchasePending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during restore: $e')),
      );
    }
  }

  bool _hasActiveSubscription() {
    return _purchases.any((purchase) =>
    purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored);
  }

  Column _buildProductList() {
    final PurchaseController controller = Get.put(PurchaseController());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Map<String, PurchaseDetails> purchases = {
      for (var purchase in _purchases) purchase.productID: purchase
    };

    return Column(
      children: _products.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value;
        final purchase = purchases[product.id];
        final isSelected = controller.selectedPlanIndex.value == index;

        final double priceValue = double.tryParse(
          product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
        ) ??
            0;
        final actualPrice = (priceValue * 2).toStringAsFixed(2);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Stack(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isSelected ? kSkyBlueColor : kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ListTile(
                    onTap: () {
                      controller.selectedPlanIndex.value = index;
                      _buyProduct(product, purchase);
                    },
                    title: Text(
                      isLifetimeProduct(product.id)
                          ? 'Lifetime Subscription'
                          : '1 Year Subscription',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isSelected ? kWhite : kBlack,
                      ),
                    ),
                    subtitle: Text(
                      isLifetimeProduct(product.id)?
                      product.description :"Ads free Version \nPremium features",
                      style: context.textTheme.bodySmall?.copyWith(
                        color:kWhite.withOpacity(0.9),
                      ),
                    ),
                    trailing: isLifetimeProduct(product.id)
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
              ),
              if (isLifetimeProduct(product.id))
                Positioned(
                  top: -15,
                  right: 10,
                  child: Image.asset(
                    'assets/images/offer.png',
                    width: 35,
                    height: 42,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
