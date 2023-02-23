import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';

class NotifyHandleScreen extends StatelessWidget {
  NotifyHandleScreen({
    required this.notifyID,
    super.key,
  });
  int notifyID;

  NotifyInfoModel? getNotifyInfo(int notifyID) {
    var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
    var notifyInfo = notifyBox.getAt(notifyID);
    return notifyInfo;
  }

  @override
  Widget build(BuildContext context) {
    var notifyInfo = getNotifyInfo(notifyID);
    return Scaffold(
      appBar: AppBar(
        title: Text(notifyInfo!.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Text("Status : ${notifyInfo.status}"),
          ),
          GestureDetector(
            onTap: () {
              notifyInfo.status = 0;
              notifyInfo.save();
              Get.back();
            },
            child: const Text("Change Status"),
          )
        ],
      ),
    );
  }
}
