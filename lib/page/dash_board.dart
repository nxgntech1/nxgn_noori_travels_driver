// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/dash_board_controller.dart';
import 'package:cabme_driver/page/new_ride_screens/new_ride_screen.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user_model.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  DateTime backPress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: ConstantColors.primary,
    // ));
    return GetX<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        controller.getDrawerItem();
        return WillPopScope(
          onWillPop: () async {
            final timeGap = DateTime.now().difference(backPress);
            final cantExit = timeGap >= const Duration(seconds: 2);
            backPress = DateTime.now();
            if (cantExit) {
              const snack = SnackBar(
                content: Text(
                  'Press Back button again to Exit',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return false; // false will do nothing when back press
            } else {
              return true; // true will exit the app
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  controller.selectedDrawerIndex.value != 0
                      ? ConstantColors.primary
                      : ConstantColors.background,
              elevation: 0,
              centerTitle: controller.selectedDrawerIndex.value != 0?false:true,
              title: controller.selectedDrawerIndex.value != 0
                  ? Text(
                      controller.drawerItems[controller.selectedDrawerIndex.value].title.toString(),
                      style: TextStyle(color: controller.selectedDrawerIndex.value == 0?Colors.black:Colors.white,fontSize: 18),
                    )
                  : Container(
                      width: Responsive.width(50, context),
                      height: Responsive.height(5.5, context),
                      decoration: BoxDecoration(
                        color: ConstantColors.textFieldBoarderColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            alignment: Alignment(controller.isActive.value == true ? -1 : 1, 0),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              width: Responsive.width(26, context),
                              height: Responsive.height(8, context),
                              decoration: BoxDecoration(
                                color: ConstantColors.primary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              print(controller.userModel.value.userData!.statutVehicule);
                              print(controller.userModel.value.userData!.isVerified);
                              // if (controller.userModel.value.userData!.statutVehicule == "no") {
                              //   _showAlertDialog(context, "vehicleInformation");
                              // } else 
                              if (controller.userModel.value.userData!.isVerified == "no" || controller.userModel.value.userData!.isVerified!.isEmpty) {
                                _showAlertDialog(context, "document");
                              } else {
                                ShowToastDialog.showLoader("Please wait");
                                controller.isActive.value = true;
                                Map<String, dynamic> bodyParams = {
                                  'id_driver': Preferences.getInt(Preferences.userId),
                                  'online': controller.isActive.value ? 'yes' : 'no',
                                };

                                await controller.changeOnlineStatus(bodyParams).then((value) {
                                  if (value != null) {
                                    if (value['success'] == "success") {
                                      UserModel userModel = Constant.getUserData();
                                      userModel.userData!.online = value['data']['online'];
                                      Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
                                      controller.getUsrData();
                                      ShowToastDialog.showToast(value['message']);
                                    } else {
                                      ShowToastDialog.showToast(value['error']);
                                    }
                                  }
                                });
                                ShowToastDialog.closeLoader();
                              }
                            },
                            child: Align(
                              alignment: const Alignment(-1, 0),
                              child: Container(
                                width: Responsive.width(26, context),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Online'.tr,
                                  style: GoogleFonts.poppins(color: controller.isActive.value == true ? Colors.black : Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              ShowToastDialog.showLoader("Please wait".tr);
                              controller.isActive.value = false;
                              Map<String, dynamic> bodyParams = {
                                'id_driver': Preferences.getInt(Preferences.userId),
                                'online': controller.isActive.value ? 'yes' : 'no',
                              };

                              await controller.changeOnlineStatus(bodyParams).then((value) {
                                if (value != null) {
                                  if (value['success'] == "success") {
                                    UserModel userModel = Constant.getUserData();
                                    userModel.userData!.online = value['data']['online'];
                                    Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
                                    controller.getUsrData();
                                    ShowToastDialog.showToast(value['message']);
                                  } else {
                                    ShowToastDialog.showToast(value['error']);
                                  }
                                }
                              });
                              ShowToastDialog.closeLoader();
                            },
                            child: Align(
                              alignment: const Alignment(1, 0),
                              child: Container(
                                width: Responsive.width(26, context),
                                color: Colors.transparent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Offline'.tr,
                                  style: GoogleFonts.poppins(color: controller.isActive.value == false ? Colors.black : Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              // title: Text(
              //   controller.drawerItems[controller.selectedDrawerIndex.value].title.toString(),
              //   style: const TextStyle(color: Colors.black),
              // ),
              // controller.selectedDrawerIndex.value == 7
              // ? const Text(
              //     'Earnings',
              //     style: TextStyle(color: Colors.black),
              //   )
              //     : controller.selectedDrawerIndex.value == 8
              //         ? const Text(
              //             'Bank info',
              //             style: TextStyle(color: Colors.black),
              //           )
              //         : Container(),
              leading: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.getDrawerItem();
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: controller.selectedDrawerIndex.value == 0?Colors.white:ConstantColors.primary,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: ConstantColors.primary.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.menu_rounded,color: controller.selectedDrawerIndex.value != 0?Colors.white:Colors.black,)
                        // Image.asset(
                        //   "assets/icons/ic_side_menu.png",
                        //   color: controller.selectedDrawerIndex.value != 0?Colors.white:Colors.black,
                        // )
                        ),
                  ),
                );
              }),
            ),
            drawer: buildAppDrawer(context, controller),
            body: const NewRideScreen(),
            //controller.getDrawerItemWidget(controller.selectedDrawerIndex.value),
          ),
        );
      },
    );
  }

  buildAppDrawer(BuildContext context, DashBoardController controller) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selectedColor: ConstantColors.primary,
        selected: false,//i == controller.selectedDrawerIndex.value,
        onTap: () => controller.onSelectItem(i,context),
      ));
    }
    return Drawer(
      child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                controller.userModel == null
                    ? Center(
                        child: CircularProgressIndicator(color: ConstantColors.primary),
                      )
                    : UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: ConstantColors.primary,
                        ),
                        currentAccountPicture: ClipOval(
                          child: Container(
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: controller.userModel.value.userData!.photoPath.toString(),
                              fit: BoxFit.fill,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/appIcon.png",
                              ),
                            ),
                          ),
                        ),
                        accountName: Text('${controller.userModel.value.userData!.prenom.toString()} ${controller.userModel.value.userData!.nom.toString()}',
                            style: const TextStyle(color: Colors.white)),
                        accountEmail: Row(
                          children: [
                            Expanded(child: Text(controller.userModel.value.userData!.email.toString(), style: const TextStyle(color: Colors.white))),
                            // SizedBox(
                            //   height: 20,
                            //   width: 50,
                            //   child: Switch(
                            //       value: controller.isActive.value,
                            //       activeColor: ConstantColors.blue,
                            //       inactiveThumbColor: Colors.red,
                            //       onChanged: (value) {
                            //         controller.isActive.value = value;
                            //
                            //         Map<String, dynamic> bodyParams = {
                            //           'id_driver': Preferences.getInt(Preferences.userId),
                            //           'online': controller.isActive.value ? 'yes' : 'no',
                            //         };
                            //
                            //         controller.changeOnlineStatus(bodyParams).then((value) {
                            //           if (value != null) {
                            //             if (value['success'] == "success") {
                            //               UserModel userModel = Constant.getUserData();
                            //               userModel.userData!.online = value['data']['online'];
                            //               Preferences.setString(Preferences.user, jsonEncode(userModel.toJson()));
                            //               controller.getUsrData();
                            //               ShowToastDialog.showToast(value['message']);
                            //             } else {
                            //               ShowToastDialog.showToast(value['error']);
                            //             }
                            //           }
                            //         });
                            //         //Do you things
                            //       }),
                            // )
                          ],
                        )),
                Column(children: drawerOptions),
                
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'V : ${Constant.appVersion.toString()}     ',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context, String type) async {
    final controllerDashBoard = Get.put(DashBoardController());

    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: Text('Information'.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your document verification is currently in progress. You will receive a call once it is verified and receive the ride notification'.tr),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'.tr),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Yes'.tr),
              onPressed: () {
                if (type == "document") {
                  controllerDashBoard.onSelectItem(1,context);
                } else {
                  controllerDashBoard.onSelectItem(4,context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}
