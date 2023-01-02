// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:alaman/Config/app_config.dart';

class QuizDetailsTabController extends GetxController
    with GetTickerProviderStateMixin {
  var myTabs;

  TabController controller;

  @override
  void onInit() {
    super.onInit();
    myTabs = <Tab>[
      Tab(text: "${stctrl.lang["Instruction"]}"),
      Tab(text: "${stctrl.lang["Q/A"]}"),
    ];
    controller =
        TabController(vsync: this, length: myTabs.length, initialIndex: 0);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
