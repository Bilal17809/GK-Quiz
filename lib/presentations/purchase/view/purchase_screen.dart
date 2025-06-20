import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:template/core/constant/constant.dart';
import 'package:template/core/routes/routes_name.dart';
import 'package:template/core/theme/app_colors.dart';
import 'package:template/core/theme/app_styles.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/elongated_button.dart';
import '../controller/purchase_controller.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

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
                SizedBox(height: 12),
                // Plans using ListView.builder with Card and ListTile
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mobileWidth * 0.04),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        bool isSelected =
                            controller.selectedPlanIndex.value == index;
                        return Card(
                          margin: kCardMargin,
                          color: isSelected ? kSkyBlueColor : kWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          child: ListTile(
                            onTap: () => controller.selectPlan(index),
                            title: Text(
                              index == 0 ? 'Monthly Plan' : 'Yearly Plan',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: isSelected ? kWhite : kBlack,
                              ),
                            ),
                            subtitle: Text(
                              '3 Days Free Trial',
                              style: context.textTheme.bodySmall?.copyWith(
                                color:
                                    isSelected
                                        ? kWhite.withValues(alpha: 0.7)
                                        : greyColor,
                              ),
                            ),
                            trailing: Text(
                              index == 0 ? 'Rs 1,000.00' : 'Rs 2,000.00',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: isSelected ? kWhite : kBlack,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: 8),
                // Cancel info
                Text(
                  '>> Cancel anytime atleast 24 hours before renewal',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: mobileWidth * 0.03,
                  ),
                ),
                SizedBox(height: 12),
                // Start Free Trial Button
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                    child: ElongatedButton(
                      height: mobileHeight * 0.07,
                      width: double.infinity,
                      color: kSkyBlueColor,
                      borderRadius: BorderRadius.circular(12),
                      onTap:
                          controller.isLoading.value
                              ? null
                              : () async {
                                await controller.startFreeTrial();
                                toastification.show(
                                  type: ToastificationType.warning,
                                  title: const Text('Success'),
                                  description: Text(
                                    'Free trial started successfully',
                                  ),
                                  style: ToastificationStyle.flatColored,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  primaryColor: skyColor,
                                  margin: const EdgeInsets.all(8),
                                  closeOnClick: true,
                                  alignment: Alignment.bottomCenter,
                                );
                              },
                      child:
                          controller.isLoading.value
                              ? SizedBox(
                                height: mobileWidth * 0.05,
                                width: mobileWidth * 0.05,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Start Free Trial',
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: kWhite,
                                ),
                              ),
                    ),
                  ),
                ),
                // Footer links
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kBodyHp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(RoutesName.termsScreen);
                        },
                        child: Text(
                          'Terms & Conditions',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: kSkyBlueColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(RoutesName.unsubscribeInfoScreen);
                        },
                        child: Text(
                          'How to unsubscribe?',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: kSkyBlueColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mobileHeight * 0.02),
              ],
            ),
          ),
          // Close button (positioned at top right)
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
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
}
