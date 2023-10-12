import 'package:flutter/material.dart';

class AppLifeCycleManager extends StatefulWidget {
  const AppLifeCycleManager({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifeCycleManager> createState() => _AppLifeCycleManagerState();
}

class _AppLifeCycleManagerState extends State<AppLifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    //print('AppLifecyccleState: $state');
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        // print('AppLifecyccleState: resumed');
        // final service = FlutterBackgroundService();
        // if (await service.isRunning()) {
        //   print('invoke : stopService');
        //   service.invoke('stopService');
        // } else {
        //   // service.startService();
        // }
        break;
      case AppLifecycleState.paused:
        // print('AppLifecyccleState: paused');
        // final service = FlutterBackgroundService();
        // if (!await service.isRunning()) {
        //   print('start service');
        //   await service.startService();
        // }
        // print('setAsBackground');
        // service.invoke('setAsForeground');
        break;
      case AppLifecycleState.detached:
        // print('AppLifecyccleState: deached');

        break;
      case AppLifecycleState.hidden:
        // Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
