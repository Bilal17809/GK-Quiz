import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';


class TrackingController extends GetxController {
  // Request App Tracking Transparency permission
  Future<void> requestTrackingPermission() async {
    final trackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();

    // Handle different tracking statuses
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
