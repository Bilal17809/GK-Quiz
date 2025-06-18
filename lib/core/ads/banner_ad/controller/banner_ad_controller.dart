import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdController extends GetxController {
  final Rx<BannerAd?> bannerAd = Rx<BannerAd?>(null);
  final RxBool isLoaded = false.obs;
  final AdSize adSize;
  final String uniqueId;

  BannerAdController({this.adSize = AdSize.banner, required this.uniqueId});

  @override
  void onInit() {
    super.onInit();
    _loadAd();
  }

  void _loadAd() {
    bannerAd.value?.dispose();

    final ad = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isLoaded.value = true;
          bannerAd.value = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isLoaded.value = false;
          bannerAd.value = null;
          print('Banner ad failed to load: $error');
          Future.delayed(const Duration(seconds: 30), _loadAd);
        },
      ),
    );
    ad.load();
  }

  void reloadAd() {
    _loadAd();
  }

  @override
  void onClose() {
    bannerAd.value?.dispose();
    super.onClose();
  }
}
