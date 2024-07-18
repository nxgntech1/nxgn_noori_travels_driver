import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/driver_location_update.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/page/auth_screens/login_screen.dart';
import 'package:cabme_driver/page/contact_us/contact_us_screen.dart';
import 'package:cabme_driver/page/dash_board.dart';
import 'package:cabme_driver/page/document_status/document_status_screen.dart';
import 'package:cabme_driver/page/my_profile/my_profile_screen.dart';
import 'package:cabme_driver/page/new_ride_screens/new_ride_screen.dart';
import 'package:cabme_driver/page/privacy_policy/privacy_policy_screen.dart';
import 'package:cabme_driver/page/terms_of_service/terms_of_service_screen.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../themes/button_them.dart';
import '../themes/constant_colors.dart';

class DashBoardController extends GetxController {
  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;

  @override
  void onInit() {
    getUsrData();
    locationSubscription = location.onLocationChanged.listen((event) {});
    getCurrentLocation();
    updateToken();
    updateCurrentLocation();
    getPaymentSettingData();

    super.onInit();
  }

  updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      updateFCMToken(token);
    }
  }

  getCurrentLocation() async {
    LocationData location = await Location().getLocation();
    List<geocoding.Placemark> placeMarks = await geocoding.placemarkFromCoordinates(location.latitude ?? 0.0, location.longitude ?? 0.0);
    for (var i = 0; i < Constant.allTaxList.length; i++) {
      if (placeMarks.first.country.toString().toUpperCase() == Constant.allTaxList[i].country!.toUpperCase()) {
        Constant.taxList.add(Constant.allTaxList[i]);
      }
    }
    print(Constant.taxList.length);
    setCurrentLocation(location.latitude.toString(), location.longitude.toString());
  }

  getDrawerItem() {
    drawerItems = [
      DrawerItem('All Rides'.tr, CupertinoIcons.car_detailed),
      // DrawerItem('confirmed'.tr, CupertinoIcons.checkmark_circle),
      // DrawerItem('on_ride'.tr, Icons.directions_boat_outlined),
      // DrawerItem('completed'.tr, Icons.incomplete_circle_outlined),
      // DrawerItem('canceled'.tr, Icons.cancel_outlined),
      // if (Constant.parcelActive == "yes" && userModel.value.userData!.parcelDelivery.toString() == "yes") DrawerItem('parcel_service'.tr, Icons.airport_shuttle),
      // if (Constant.parcelActive == "yes" && userModel.value.userData!.parcelDelivery.toString() == "yes") DrawerItem('all_parcel'.tr, Icons.airport_shuttle),
      DrawerItem('Documents'.tr, Icons.domain_verification),
      //DrawerItem('Vehicle information'.tr, Icons.car_rental_sharp),
      DrawerItem('my_profile'.tr, Icons.person_outline),
      // DrawerItem('Car Service History'.tr, Icons.miscellaneous_services),
      //DrawerItem('My Earnings'.tr, Icons.account_balance_wallet_outlined),
      //DrawerItem('Add Bank'.tr, Icons.account_balance),
      // DrawerItem('change_language'.tr, Icons.language),
      DrawerItem('contact_us'.tr, Icons.rate_review_outlined),
      DrawerItem('term_service'.tr, Icons.design_services),
      DrawerItem('privacy_policy'.tr, Icons.privacy_tip),
      DrawerItem('sign_out'.tr, Icons.logout),
    ];
  }

  Rx<UserModel> userModel = UserModel().obs;

  getUsrData() async {
    userModel.value = Constant.getUserData();
    getDrawerItem();
    Map<String, String> bodyParams = {
      'phone': userModel.value.userData!.phone.toString(),
      'user_cat': "driver",
    };
    final responsePhone = await http.post(Uri.parse(API.getProfileByPhone), headers: API.header, body: jsonEncode(bodyParams));
    Map<String, dynamic> responseBodyPhone = json.decode(responsePhone.body);
    if (responsePhone.statusCode == 200 && responseBodyPhone['success'] == "success") {
      ShowToastDialog.closeLoader();
      UserModel? value = UserModel.fromJson(responseBodyPhone);
      Preferences.setString(Preferences.user, jsonEncode(value));
      userModel.value = value;
      isActive.value = userModel.value.userData!.online == "yes" ? true : false;
      if (userModel.value.userData!.isVerified == "no" || userModel.value.userData!.isVerified!.isEmpty) {
        //selectedDrawerIndex.value = 1;
        Get.to(DocumentStatusScreen());
      }
    }
  }

  RxBool isActive = true.obs;
  RxInt selectedDrawerIndex = 0.obs;
  var drawerItems = [];
  onSelectItem(int index, BuildContext context) {
    getDrawerItem();
    selectedDrawerIndex.value = 0;
    Get.back();
    if (index == 0) {
      //Get.to(const BookingScreen());
    } else if (index == 1) {
      Get.to(DocumentStatusScreen());
    } else if (index == 2) {
      Get.to(MyProfileScreen());
    } else if (index == 3) {
      Get.to(const ContactUsScreen());
    } else if (index == 4) {
      Get.to(const TermsOfServiceScreen());
    } else if (index == 5) {
      Get.to(const PrivacyPolicyScreen());
    } else if (index == 6) {
      _showLogoutDialog(context);
    } else {
      Get.to(const NewRideScreen());
    }
    // }
    //Get.back();
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 30),
                      //Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonThem.buildButton(Get.context!, title: "Yes".tr, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () {
                            Preferences.clearKeyData(Preferences.isLogin);
                            Preferences.clearKeyData(Preferences.user);
                            Preferences.clearKeyData(Preferences.userId);
                            Get.offAll(const LoginScreen());
                          }, btnHeight: 35, btnWidthRatio: 0.3),
                          // const SizedBox(
                          //   width: 15,
                          // ),
                          ButtonThem.buildBorderButton(Get.context!,
                              title: "No".tr,
                              btnHeight: 35,
                              btnWidthRatio: 0.3,
                              btnColor: Colors.white,
                              txtColor: ConstantColors.primary,
                              onPress: () => Get.back(),
                              btnBorderColor: ConstantColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  updateCurrentLocation() async {
    if (isActive.value) {
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdateUnit.toString()));
        locationSubscription = location.onLocationChanged.listen((locationData) {
          LocationData currentLocation = locationData;
          Constant.currentLocation = locationData;
          DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
              rotation: currentLocation.heading.toString(),
              active: isActive.value,
              driverId: Preferences.getInt(Preferences.userId).toString(),
              driverLatitude: currentLocation.latitude.toString(),
              driverLongitude: currentLocation.longitude.toString());
          Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set(driverLocationUpdate.toJson());
          setCurrentLocation(currentLocation.latitude.toString(), currentLocation.longitude.toString());
        });
      } else {
        location.requestPermission().then((permissionStatus) {
          if (permissionStatus == PermissionStatus.granted) {
            location.enableBackgroundMode(enable: true);
            location.changeSettings(accuracy: LocationAccuracy.high, distanceFilter: double.parse(Constant.driverLocationUpdateUnit.toString()));
            locationSubscription = location.onLocationChanged.listen((locationData) {
              LocationData currentLocation = locationData;
              Constant.currentLocation = locationData;
              DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
                  rotation: currentLocation.heading.toString(),
                  active: isActive.value,
                  driverId: Preferences.getInt(Preferences.userId).toString(),
                  driverLatitude: currentLocation.latitude.toString(),
                  driverLongitude: currentLocation.longitude.toString());
              Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set(driverLocationUpdate.toJson());
              setCurrentLocation(currentLocation.latitude.toString(), currentLocation.longitude.toString());
            });
          }
        });
      }
    } else {
      DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
          rotation: "0", active: false, driverId: Preferences.getInt(Preferences.userId).toString(), driverLatitude: "0", driverLongitude: "0");
      Constant.driverLocationUpdate.doc(Preferences.getInt(Preferences.userId).toString()).set(driverLocationUpdate.toJson());
    }
  }

  // deleteCurrentOrderLocation() {
//   RideData? rideData = Constant.getCurrentRideData();
//   if (rideData != null) {
//     String orderId = "";
//     if (rideData.rideType! == 'driver') {
//       orderId = '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}';
//     } else {
//       orderId = (double.parse(rideData.idUserApp.toString()) < double.parse(rideData.idConducteur!))
//           ? '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}'
//           : '${rideData.idConducteur}-${rideData.id}-${rideData.idUserApp}';
//     }
//     Location location = Location();
//     location.enableBackgroundMode(enable: false);
//     Constant.locationUpdate.doc(orderId).delete().then((value) async {
//       await updateCurrentLocation(data: rideData);
//       Preferences.clearKeyData(Preferences.currentRideData);
//       locationSubscription.cancel();
//     });
//   }
// }

  getDrawerItemWidget(int pos) {
    // if (Constant.parcelActive == "yes" && userModel.value.userData!.parcelDelivery.toString() == "yes") {
    switch (pos) {
      case 0:
        return const NewRideScreen();
      // case 1:
      // return SearchParcelScreen();
      // case 2:
      //   return const AllParcelScreen();
      case 1:
        return DocumentStatusScreen();
      // case 4:
      //   return const VehicleInfoScreen();
      case 2:
        return MyProfileScreen();
      // case 6:
      //   return const CarServiceBookHistory();
      // case 7:
      //   return WalletScreen();
      // case 8:
      //   return const ShowBankDetails();
      // case 9:
      //   return const LocalizationScreens(intentType: "dashBoard");
      case 3:
        return const ContactUsScreen();
      case 4:
        return const TermsOfServiceScreen();
      case 5:
        return const PrivacyPolicyScreen();
      default:
        return Text("Error".toString());
    }
    // } else {
    //   switch (pos) {
    //     case 0:
    //       return const NewRideScreen();
    //     case 1:
    //       return DocumentStatusScreen();
    //     case 2:
    //       return const VehicleInfoScreen();
    //     case 3:
    //       return MyProfileScreen();
    //     case 4:
    //       return const CarServiceBookHistory();
    //     case 5:
    //       return WalletScreen();
    //     case 6:
    //       return const ShowBankDetails();
    //     case 7:
    //       return const LocalizationScreens(intentType: "dashBoard");
    //     case 8:
    //       return const ContactUsScreen();
    //     case 9:
    //       return const TermsOfServiceScreen();
    //     case 10:
    //       return const PrivacyPolicyScreen();
    //     default:
    //       return Text("Error".toString());
    //   }
    // }
  }

  Future<dynamic> setCurrentLocation(String latitude, String longitude) async {
    try {
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'user_cat': userModel.value.userData!.userCat,
        'latitude': latitude,
        'longitude': longitude
      };
      final response = await http.post(Uri.parse(API.updateLocation), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> updateFCMToken(String token) async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId),
        'fcm_id': token,
        'device_id': "",
        'user_cat': userModel.value.userData!.userCat
      };
      final response = await http.post(Uri.parse(API.updateToken), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {}
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> changeOnlineStatus(bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changeStatus), headers: API.header, body: jsonEncode(bodyParams));

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        updateCurrentLocation();
        return responseBody;
      } else {
        ShowToastDialog.closeLoader();
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getPaymentSettingData() async {
    try {
      final response = await http.get(Uri.parse(API.paymentSetting), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        Preferences.setString(Preferences.paymentSetting, jsonEncode(responseBody));
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
      } else {}
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
