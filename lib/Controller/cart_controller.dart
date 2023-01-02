// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:alaman/Controller/account_controller.dart';
import 'package:alaman/Model/Cart/ModelCartList.dart';
import 'package:alaman/Service/RemoteService.dart';

class CartController extends GetxController {
  final AccountController accountController = Get.put(AccountController());
  GetStorage userToken = GetStorage();

  @override
  void onInit() {
    getCartList();
    super.onInit();
  }

  var isLoading = false.obs;

  var isPaymentLoading = false.obs;

  // ignore: deprecated_member_use
  var cartList = List<CartList>().obs;

  var paymentList = [].obs;

  String remove;

  var coupon;

  var tokenKey = "token";

  var isCouponAvailable = false.obs;

  var total = 0.0.obs;

  var totalValue = 0.0.obs;

  var couponMsg = "".obs;

  dynamic totalAmount() {
    if (isCouponAvailable(false)) {
      totalValue = total;
      return totalValue.toString();
    }
    total(0.0);
    for (var i = 0; i < cartList.length; i++) {
      total += cartList[i].price;
    }
    return total.toString();
  }

  Future applyCoupon({String code, dynamic totalAmount}) async {
    String token = await accountController.userToken.read(tokenKey);
    try {
      // isLoading(true);
      var coupons = await RemoteServices.couponApply(
          token: token, code: code, totalAmount: totalAmount);
      if (coupons['success'] == true) {
        isCouponAvailable(true);
        total.value =
            double.parse(coupons['total'].toString().replaceAll(',', ''))
                .toDouble();
        couponMsg.value = coupons['message'];
        update();
        return coupons;
      } else {
        isCouponAvailable(false);
        couponMsg.value = coupons['message'];
        update();
      }
    } finally {
    }
  }

  removeCoupon() {
    isCouponAvailable(false);
    couponMsg.value = "";
    totalAmount();
  }

  Future<List<CartList>> getCartList() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);
      cartList.value = [];
      isCouponAvailable(false);
      couponMsg.value = "";
      var products = await RemoteServices.getCartList(token);
      if (products != null) {
        cartList.value = products;
      }
      return products;
    } finally {
      isLoading(false);
    }
  }

  Future<String> removeToCart(int id) async {
    String token = await accountController.userToken.read(tokenKey);
    try {
      isLoading(true);
      var products = await RemoteServices.remoteCartRemove(token, id);
      if (products != null) {
        removeCoupon();
        cartList.value = [];
        return remove = products;
      } else {
        return null;
      }
    } finally {
      isLoading(false);
    }
  }
}
