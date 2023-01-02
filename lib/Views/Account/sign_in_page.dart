// Flutter imports:
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:alaman/Config/app_config.dart';

// Project imports:
import 'package:alaman/Controller/dashboard_controller.dart';
import 'package:alaman/Views/Account/register_page.dart';

import 'package:alaman/utils/widgets/AppBarWidget.dart';

// ignore: must_be_immutable
class SignInPage extends GetView<DashboardController> {
  final _googleSignIn = GoogleSignIn();

  Map<String, dynamic> userData;
  AccessToken _accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showSearch: false,
        goToSearch: false,
        showFilterBtn: false,
        showBack: false,
      ),
      body: Obx(() {
        if (controller.isRegisterScreen.value) {
          return RegisterPage();
        } else {
          return Container(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 25,
                      ),
                      height: 70,
                      width: 70,
                      child: Image.asset('images/signin_img.png'),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: Text(
                          "${stctrl.lang['Sign In']}",
                          style: Get.textTheme.subtitle1.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: controller.email,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 13, bottom: 0, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: '${stctrl.lang['Enter Your Email']}',
                          hintStyle: Get.textTheme.subtitle1.copyWith(
                            fontSize: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            size: 24,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: controller.password,
                        obscureText: controller.obscurePass.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 13, bottom: 0, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "${stctrl.lang["Password"]}",
                          hintStyle: Get.textTheme.subtitle1.copyWith(
                            fontSize: 14,
                          ),
                          suffixIcon: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              controller.obscurePass.value =
                                  !controller.obscurePass.value;
                            },
                            child: Icon(
                              controller.obscurePass.value
                                  ? Icons.lock_rounded
                                  : Icons.lock_open,
                              size: 24,
                              color: Color.fromRGBO(142, 153, 183, 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          controller.loginMsg.value,
                          style: TextStyle(
                            color: Color(0xff8E99B7),
                            fontSize: 14,
                            fontFamily: 'AvenirNext',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 100),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "${stctrl.lang["Sign In"]}",
                          ),
                        ),
                        onTap: () async {
                          controller.obscurePass.value = true;
                          await controller.fetchUserLogin();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (facebookLogin || googleLogin)
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Text(
                              "${stctrl.lang["Or continue with"]}",
                              style: Get.textTheme.subtitle1.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          facebookLogin
                              ? InkWell(
                                  onTap: () async {
                                    final LoginResult result = await FacebookAuth
                                        .instance
                                        .login(); // by default we request the email and the public profile
                                    if (result.status == LoginStatus.success) {
                                      _accessToken = result.accessToken;
                                      _printCredentials();

                                      final fbData = await FacebookAuth.instance
                                          .getUserData();
                                      userData = fbData;

                                      final _getToken =
                                          FacebookResponse.fromJson(
                                              _accessToken.toJson());

                                      final _getUser =
                                          FacebookUser.fromJson(userData);

                                      Map data = {
                                        "provider_id": _getUser.id,
                                        "provider_name": "facebook",
                                        "name": _getUser.name,
                                        "email": _getUser.email,
                                        "token": _getToken.token.toString(),
                                      };

                                      await controller
                                          .socialLogin(data)
                                          .then((value) async {
                                        if (value == true) {
                                          controller.isLoading(false);
                                        } else {
                                          await FacebookAuth.instance.logOut();
                                        }
                                      });
                                    } else {
                                      controller.loginMsg.value =
                                          result.message.toString();
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            'images/facebook_logo.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${stctrl.lang["Facebook"]}",
                                          style:
                                              Get.textTheme.subtitle1.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            width: 20,
                          ),
                          googleLogin
                              ? InkWell(
                                  onTap: () async {
                                    try {
                                      GoogleSignInAccount googleSignInAccount =
                                          await _googleSignIn.signIn();

                                      await googleSignInAccount.authentication
                                          .then((value) async {
                                        Map data = {
                                          "provider_id": googleSignInAccount.id,
                                          "provider_name": "google",
                                          "name":
                                              googleSignInAccount.displayName,
                                          "email": googleSignInAccount.email,
                                          "token": value.idToken.toString(),
                                        };

                                        await controller
                                            .socialLogin(data)
                                            .then((value) {
                                          if (value == true) {
                                            controller.isLoading(false);
                                          } else {
                                            _googleSignIn.signOut();
                                          }
                                        });
                                      });
                                    } catch (e) {
                                      controller.loginMsg.value =
                                          "${stctrl.lang["Login Cancelled"]}";
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            'images/google_logo.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${stctrl.lang["Google"]}",
                                          style:
                                              Get.textTheme.subtitle1.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          controller.showRegisterScreen();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "${stctrl.lang["Don\'t have an Account? Register now"]}",
                            style: Get.textTheme.subtitle1.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                  ],
                );
              }
            }),
          );
        }
      }),
    );
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken.toJson()),
    );
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    this.userId,
    this.token,
  });

  String userId;
  String token;

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        userId: json["userId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

FacebookUser facebookUserFromJson(String str) =>
    FacebookUser.fromJson(json.decode(str));

String facebookUserToJson(FacebookUser data) => json.encode(data.toJson());

class FacebookUser {
  FacebookUser({
    this.email,
    this.id,
    this.name,
  });

  String email;
  String id;
  String name;

  factory FacebookUser.fromJson(Map<String, dynamic> json) => FacebookUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
