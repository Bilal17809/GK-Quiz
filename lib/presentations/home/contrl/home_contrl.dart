import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';
import 'dart:io';

class TrackingController extends GetxController {
  Future<void> requestTrackingPermission() async {
    if (!Platform.isIOS) {
      return;
    }
    final trackingStatus =
    await AppTrackingTransparency.requestTrackingAuthorization();

    switch (trackingStatus) {
      case TrackingStatus.notDetermined:
        print('User has not yet decided');
        break;
      case TrackingStatus.denied:
        print('User denied tracking');
        break;
      case TrackingStatus.authorized:
        print('User granted tracking permission');
        break;
      case TrackingStatus.restricted:
        print('Tracking restricted');
        break;
      default:
        print('Unknown tracking status');
    }
  }
}
