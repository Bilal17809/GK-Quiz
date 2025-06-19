import 'package:flutter/material.dart';
import '../controller/open_app_controller.dart';

class OpenAppAdWidget extends StatefulWidget {
  final Widget child;

  const OpenAppAdWidget({super.key, required this.child});

  @override
  State<OpenAppAdWidget> createState() => _OpenAppAdWidgetState();
}

class _OpenAppAdWidgetState extends State<OpenAppAdWidget>
    with WidgetsBindingObserver {
  late final OpenAppAdController _adController;
  DateTime? _lastPausedTime;

  @override
  void initState() {
    super.initState();
    _adController = OpenAppAdController.instance;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _lastPausedTime = DateTime.now();
        break;
      case AppLifecycleState.resumed:
        _handleAppResume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _handleAppResume() {
    if (_adController.isFirstLaunch || _lastPausedTime == null) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      _showAdIfAvailable();
    });

    _lastPausedTime = null;
  }

  void _showAdIfAvailable() {
    if (!_adController.isAdAvailable) return;

    _adController.showAd();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
