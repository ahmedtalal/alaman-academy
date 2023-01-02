// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:alaman/Controller/account_controller.dart';
import 'package:alaman/Controller/cart_controller.dart';
import 'package:alaman/Controller/dashboard_controller.dart';
import 'package:alaman/Controller/home_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<AccountController>(() => AccountController());
  }

}
