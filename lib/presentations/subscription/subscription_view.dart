// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../remove_ads_contrl/remove_ads_contrl.dart';
// import '../term/term.dart';
// import '../them_controller/them_controller.dart';
//
// final bool _kAutoConsume = Platform.isIOS || true;
//
// const String _kConsumableId = 'consumable';
// const String _kUpgradeId = 'upgrade';
// const String _kSilverSubscriptionId = 'com.advanceenglishdictionary.Ads';
// const List<String> _kProductIds = <String>[
//   _kConsumableId,
//   _kUpgradeId,
//   _kSilverSubscriptionId,
// ];
//
// class Subscriptions extends StatefulWidget {
//   @override
//   State<Subscriptions> createState() => _SubscriptionsState();
// }
//
// class _SubscriptionsState extends State<Subscriptions> {
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
//   final ThemeController themeController = Get.put(ThemeController());
//   final RemoveAds removeAdsController = Get.put(RemoveAds());
//
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
//
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
//
//   @override
//   Widget build(BuildContext context) {
//     final check = themeController.isDarkMode.value;
//     return Scaffold(
//       backgroundColor:Colors.white,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return _buildBody(constraints, check);
//         },
//       ),
//     );
//   }
//
//   Widget _buildBody(BoxConstraints constraints, bool isDarkMode) {
//     final screenWidth = constraints.maxWidth;
//     final screenHeight = constraints.maxHeight;
//     final check = themeController.isDarkMode.value;
//
//
//     // Condition for smaller screens (less than 600px width)
//     bool isSmallScreen = screenWidth < 600;
//     bool isSubscribed = removeAdsController.isSubscribedGet.value;
//
//
//     if (_loading) {
//       return Center(child: CircularProgressIndicator());
//     }
//     if (_queryProductError != null) {
//       return Center(child: Text(_queryProductError!));
//     }
//
//     final List<Map<String, dynamic>> items = [
//       {'icon': 'assets/trial/free-trial.png', 'text': 'Free Trial'},
//       {'icon': 'assets/trial/book.png', 'text': 'AI Dictionary'},
//       {'icon': 'assets/trial/regulation.png', 'text': 'Quizzes'},
//       {'icon': 'assets/trial/interactive.png', 'text': 'AI Translation'},
//     ];
//
//     return Stack(
//       children: [
//         ListView(
//           children: [
//             Column(
//               children: [
//                 // Row containing the close button
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.start, // Ensure it aligns to the top
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 0, right: 10),  // Reduce padding to 0 top space
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.close,
//                           size: isSmallScreen ? screenHeight * 0.03 : screenHeight * 0.04,
//                           color:Colors.black,
//                         ),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Image directly below the close button, with reduced vertical space
//                 Image.asset(
//                   'assets/subs.png',
//                   height: isSmallScreen ? screenHeight * 0.4 : screenHeight * 0.5,
//                   fit: BoxFit.fitHeight,  // Use BoxFit.cover if you want to fill the area
//                   alignment: Alignment.topCenter,  // Aligns the image at the top
//                 ),
//               ],
//             ),
//             SizedBox(height: isSmallScreen ? 10 : screenHeight * 0.01),  // Reduce the gap after image
//             Center(
//               child: Column(
//                 children: [
//                   isSubscribed?
//                   Text("Ads free version",
//                       style:TextStyle(fontSize: 20,
//                           fontWeight: FontWeight.w500,))
//                       :Text("Go to Premium",
//                       style:TextStyle(fontSize: 20,
//                         fontWeight: FontWeight.w500,)),
//                   const SizedBox(height: 8),
//                   Text("Unlock All Features",
//                       style:TextStyle(fontSize: 20,
//                         fontWeight: FontWeight.w500,)),
//                 ],
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 12 : screenHeight * 0.02),
//             SizedBox(
//               height: isSmallScreen ? 60 : screenHeight * 0.08,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(4.0),  // Reduced padding
//                     child: Container(
//                       width: screenWidth * 0.4,
//                       margin: const EdgeInsets.symmetric(horizontal: 2), // Reduced margin
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: check ? Colors.grey.shade300 : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 2,
//                             offset: Offset(1, 1),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               items[index]['icon'],
//                               width: isSmallScreen ? 24 : screenHeight * 0.050,
//                               height: isSmallScreen ? 24 : screenHeight * 0.050,
//                               fit: BoxFit.contain,
//                             ),
//                             SizedBox(width: isSmallScreen ? 4 : screenWidth * 0.015),
//                             Text(
//                               items[index]['text'],
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 12 : screenHeight * 0.016,
//                                 fontWeight: FontWeight.bold,
//                                 color: check ? Colors.black : Colors.blue,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildProductList(screenWidth, screenHeight, isDarkMode),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//               child: Center(
//                 child: Text(
//                   "Cancel any time, currently we are not offering free trial",
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 14 : screenHeight * 0.018,
//                     color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade700,
//                   ),
//                 ),
//               ),
//             ),
//             // const SizedBox(height: 18),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: isSmallScreen ? 20 : screenWidth * 0.07),
//                   child: InkWell(
//                     onTap: () {
//                       Get.to(TermScreen());
//                     },
//                     child: Row(
//                       children: [
//                         Text(
//                           "Term and conditions",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: isSmallScreen ? 14 : screenHeight * 0.015,
//                             decoration: TextDecoration.underline,
//                             color: isDarkMode ? Colors.black : Colors.black,
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//                 // const SizedBox(height: 12),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.all(20),
//                       child: InkWell(
//                         onTap: _restorePurchases,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: _purchasePending
//                                 ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 2,
//                                 ),
//                                 SizedBox(width:6),
//                                 Text("Restoring...", style: TextStyle(color: Colors.white)),
//                               ],
//                             )
//                                 : Text(
//                               "Restore",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: screenHeight * 0.02,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//         if (_purchasePending)
//           const Opacity(
//             opacity: 0.3,
//             child: ModalBarrier(dismissible: false, color: Colors.grey),
//           ),
//       ],
//     );
//
//   }
//
//   Column _buildProductList(double screenWidth, double screenHeight, bool isDarkMode) {
//     // Calculate dynamic padding based on screen size
//     double horizontalPadding = screenWidth * 0.04;
//     double verticalPadding = screenHeight * 0.01;
//     bool isSmallScreen = screenWidth < 600;
//
//
//     final Map<String, PurchaseDetails> purchases = {
//       for (var purchase in _purchases) purchase.productID: purchase
//     };
//     bool isSubscribed = removeAdsController.isSubscribedGet.value;
//     return Column(
//       children: _products.map((product) {
//         final purchase = purchases[product.id];
//         return isSubscribed
//             ? Padding(
//           padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//           child: Text("You are on the ads-free version!",style:TextStyle()),
//         )
//             : Padding(
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//           child: Card(
//             color:Colors.blue,
//             elevation: 1.0,
//             margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
//             child: ListTile(
//               title: Text(
//                 'Life Time Subscription',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize:isSmallScreen? 16:screenHeight*0.02,
//                   color: Colors.white,
//                 ),
//               ),
//               subtitle: Text(
//                 product.description,
//                 style: TextStyle(fontSize:isSmallScreen? 14:screenHeight*0.02,
//                     color:  Colors.white),
//               ),
//               trailing: Text(
//                 product.price,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color:  Colors.white,
//                   fontSize: isSmallScreen?16:screenHeight*0.02,
//                 ),
//               ),
//               onTap: () {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _showPurchaseDialog(context, product, purchase);
//                 });
//               },
//
//               // onTap: () => _showPurchaseDialog(context, product, purchase),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//   Future<void> _showPurchaseDialog(BuildContext context,
//       ProductDetails product, PurchaseDetails? purchase) async {
//     // Show confirmation dialog before proceeding with the purchase
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const Text('Confirm Purchase'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Are you sure you want to buy:'),
//                 const SizedBox(height: 6),
//                 Text(
//                   product.title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 6),
//                 Text('Price: ${product.price}'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             SizedBox(height:15,),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 // _showProcessingDialog(context);
//                 _buyProduct(product, purchase);
//               },
//               child: const Text('Confirm'),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   // void _showProcessingDialog(BuildContext context) {
//   //   // First, show the dialog and keep its context
//   //   showDialog<void>(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext dialogContext) {
//   //       // Start a timer that pops the dialog after 20 seconds
//   //       Timer(Duration(seconds: 20), () {
//   //         if (Navigator.of(dialogContext).canPop()) {
//   //           Navigator.of(dialogContext).pop();
//   //         }
//   //       });
//   //
//   //       return AlertDialog(
//   //         content: Row(
//   //           children: [
//   //             CircularProgressIndicator(),
//   //             SizedBox(width: 10),
//   //             Text('Processing'),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//
//   Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
//     // 1. Show custom loader
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 10),
//               Text('Preparing purchase...'),
//             ],
//           ),
//         );
//       },
//     );
//
//     try {
//       final purchaseParam = GooglePlayPurchaseParam(
//         productDetails: product,
//         changeSubscriptionParam: purchase != null
//             ? ChangeSubscriptionParam(
//           oldPurchaseDetails: purchase as GooglePlayPurchaseDetails,
//         )
//             : null,
//       );
//
//       // 2. Wait a short time to keep loader visible (and let Play UI prepare)
//       await Future.delayed(Duration(milliseconds: 1000));
//
//       // 3. Close the loader before Play dialog appears
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop();
//       }
//
//       // 4. Trigger native purchase flow
//       if (product.id == _kConsumableId) {
//         await _inAppPurchase.buyConsumable(
//           purchaseParam: purchaseParam,
//           autoConsume: _kAutoConsume,
//         );
//       } else {
//         await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//       }
//     } catch (e) {
//       print('Purchase error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Something went wrong during purchase.')),
//       );
//       if (Navigator.of(context).canPop()) {
//         Navigator.of(context).pop(); // Extra safety
//       }
//     }
//   }
//
//
//   // Future<void> _buyProduct(ProductDetails product, PurchaseDetails? purchase) async {
//   //   final purchaseParam = GooglePlayPurchaseParam(
//   //     productDetails: product,
//   //     changeSubscriptionParam: purchase != null
//   //         ? ChangeSubscriptionParam(
//   //       oldPurchaseDetails: purchase as GooglePlayPurchaseDetails,
//   //     )
//   //         : null,
//   //   );
//   //
//   //   if (product.id == _kConsumableId) {
//   //     await _inAppPurchase.buyConsumable(
//   //       purchaseParam: purchaseParam,
//   //       autoConsume: _kAutoConsume,
//   //     );
//   //   } else {
//   //     await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//   //   }
//   // }
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
//
//         // Save subscription details to shared preferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('SubscribedAED', true);
//         await prefs.setString('subscriptionId', details.productID);
//
//         // Show confirmation to the user
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Subscription purchased successfully!')),
//         );
//       }
//     }
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
//   Future<void> _restorePurchases() async {
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     if (!isAvailable) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Store is not available!')),
//       );
//       return;
//     }
//
//     setState(() {
//       _purchasePending = true;
//     });
//
//     try {
//       await _inAppPurchase.restorePurchases();
//       Timer(const Duration(seconds: 10), () {
//         if (_purchasePending) {
//           setState(() {
//             _purchasePending = false;
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Restore timed out. Please try again.')),
//             );
//           });
//         }
//       });
//
//       // IMPORTANT:  Do *nothing* else here.  The _listenToPurchaseUpdated
//       // callback (which you have in initState) will handle the actual
//       // processing of the restored purchases.
//
//     } catch (e) {
//       setState(() {
//         _purchasePending = false; // Hide loading indicator on error
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred during restore: $e')),
//       );
//     }
//   }
// // Future<void> _restorePurchases() async {
// //   final bool isAvailable = await _inAppPurchase.isAvailable();
// //   if (!isAvailable) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text('Store is not available!')),
// //     );
// //     return;
// //   }
// //
// //   // Initiate the restore process
// //   await _inAppPurchase.restorePurchases();
// //
// //   // Listen to the purchase stream to capture restored purchases
// //   final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
// //
// //   // Listen for restored purchases
// //   purchaseUpdated.listen((purchaseDetailsList) async {
// //     for (var purchaseDetails in purchaseDetailsList) {
// //       if (purchaseDetails.status == PurchaseStatus.restored) {
// //         // Handle restored purchase
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setBool('isSubscribed', true);
// //         await prefs.setString('subscriptionId', purchaseDetails.productID);
// //
// //         // Show success message to the user
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Purchase restored successfully!')),
// //         );
// //       } else if (purchaseDetails.status == PurchaseStatus.error) {
// //         // Handle errors
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Error restoring purchase: ${purchaseDetails.error}')),
// //         );
// //       }
// //     }
// //   });
// // }
//
// }
