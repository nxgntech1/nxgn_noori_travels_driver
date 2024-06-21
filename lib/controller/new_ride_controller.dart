import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/ride_model.dart';
import 'package:cabme_driver/model/user_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class NewRideController extends GetxController {
  var isLoading = true.obs;
  var rideList = <RideData>[].obs;

  RxString rideStatus = "".obs;
  RxDouble sourceLat = 0.0.obs;
  RxDouble sourceLong = 0.0.obs;
  RxDouble driverLatitude = 0.0.obs;
  RxDouble driverLongitude = 0.0.obs;
  RxString distanceFromDriverToUser = "".obs;

  Timer? timer;

  @override
  void onInit() {
    getNewRide();
    getUsrData();
    // timer = Timer.periodic(const Duration(seconds: 20), (timer) {
    //   getNewRide();
    // });
    super.onInit();
    getCurrentLocation();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  final Location currentLocation = Location();

  getCurrentLocation() async {
   // LocationData location = await currentLocation.getLocation();
final locationData = await Geolocator.getCurrentPosition();

    driverLatitude.value = locationData.latitude;
    driverLongitude.value = locationData.longitude;
  }

  Future<String?> getDistanceFromDrivertoUser(userLat, userLong) async {
    //await getCurrentLocation();
    // LocationData loc = await currentLocation.getLocation();

    // final locationData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var status = await Permission.location.request();
    if (status.isGranted) {
      double distanceInMeters = Geolocator.distanceBetween(double.parse(userLat), double.parse(userLong), driverLatitude.value, driverLongitude.value);

      // Convert distance to kilometers
      //double distanceInKm = distanceInMeters / 1000;
      String url = 'https://maps.googleapis.com/maps/api/distancematrix/json';
      http.Response restaurantToCustomerTime = await http.get(Uri.parse('$url?units=metric&origins=${double.parse(userLat)},'
          '${double.parse(userLong)}&destinations=${driverLatitude.value},${driverLongitude.value}&key=${Constant.kGoogleApiKey}'));

      var decodedResponse = jsonDecode(restaurantToCustomerTime.body);

      if (decodedResponse['status'] == 'OK' && decodedResponse['rows'].first['elements'].first['status'] == 'OK') {
        ShowToastDialog.closeLoader();
        return (decodedResponse['rows'].first['elements'].first['distance']['value'] / 1000.00).toStringAsFixed(2);
        //   estimatedTime = decodedResponse['rows'].first['elements'].first['distance']['value'] / 1000.00;
        //   if (selctedOrderTypeValue == "Delivery") {
        //     setState(() => deliveryCharges = (estimatedTime! * double.parse(deliveryCost)).toString());
        //   }
      } else {
        distanceInMeters.toStringAsFixed(2);
      }
    }
    return null;
  }

  Rx<UserModel> userModel = UserModel().obs;

  getUsrData() async {
    userModel.value = Constant.getUserData();

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
    }

    print("=======>${userModel.value.userData!.amount}");
  }

  Future<dynamic> getNewRide() async {
    try {
      final response = await http.get(Uri.parse("${API.driverAllRides}?id_driver=${Preferences.getInt(Preferences.userId)}"), headers: API.header);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        RideModel model = RideModel.fromJson(responseBody);
        rideList.value = model.data!;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        rideList.clear();

        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast('Unauthorized');
      }
    } on TimeoutException {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.message.toString());
    } on SocketException {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.message.toString());
    } on Error {
      isLoading.value = false;
      // ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      // ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  TextEditingController otpController = TextEditingController();
  TextEditingController odoStartController = TextEditingController();
  TextEditingController odoEndController = TextEditingController();

  Future<dynamic> feelNotSafe(Map<String, dynamic> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.feelSafeAtDestination), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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

  Future<dynamic> confirmedRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.conformRide), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> canceledRide(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.rejectRide), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> setOnRideRequest(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.onRideRequest), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> setCompletedRequest(Map<String, String> bodyParams, RideData data) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.setCompleteRequest), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        if (data.rideType!.toString() == "driver") {
          await cashPaymentRequest(data);
        }
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> verifyOTP({required String userId, required String rideId}) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(Uri.parse("${API.rideOtpVerify}?id_user_app=$userId&otp=${otpController.text.toString()}&ride_id=$rideId&ride_type="),
          headers: API.header);
      print("==========${response.request}");
      print("==========${response.body}");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        await http.get(Uri.parse("${API.reGenerateOtp}?id_user_app=$userId&ride_id=$rideId"), headers: API.header);

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error'].toString());
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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

  Future<dynamic> cashPaymentRequest(RideData data) async {
    List taxList = [];

    for (var v in Constant.taxList) {
      taxList.add(v.toJson());
    }
    Map<String, dynamic> bodyParams = {
      'id_ride': data.id.toString(),
      'id_driver': data.idConducteur.toString(),
      'id_user_app': data.idUserApp.toString(),
      'amount': data.montant.toString(),
      'paymethod': "Cash",
      'discount': data.discount.toString(),
      'tip': data.tipAmount.toString(),
      'tax': taxList,
      'transaction_id': DateTime.now().microsecondsSinceEpoch.toString(),
      'commission': Preferences.getString(Preferences.admincommission),
      'payment_status': "success",
    };
    try {
      // ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.payRequestCash), headers: API.header, body: jsonEncode(bodyParams));

      log('--------${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'].toString().toLowerCase() == "Success".toString().toLowerCase()) {
        ShowToastDialog.showToast("Successfully completed");

        Get.back();
        // ShowToastDialog.closeLoader();

        return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        // ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        // ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      // ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    // ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> changestatusArrived(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changestatusArrived), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        await getNewRide();
        ShowToastDialog.closeLoader();
        return 1;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> changestatusStarttrip(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changestatusStarttrip), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        await getNewRide();
        ShowToastDialog.closeLoader();
        if (responseBody['data'] == "1") {
          return 1;
        }
        // return responseBody;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> changestatusOnride(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changestatusOnride), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        await getNewRide();
        ShowToastDialog.closeLoader();
        if (responseBody['data'] == "1") {
          // rideStatus.value = "Arrived";
          return 1;
        }
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> changestatusCompleted(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changestatusCompleted), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        await getNewRide();
        ShowToastDialog.closeLoader();
        return 1;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> cashCollected(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.cashCollected), headers: API.header, body: jsonEncode(bodyParams));
      Map<String, dynamic> responseBody = json.decode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        await getNewRide();
        ShowToastDialog.closeLoader();
        return 1;
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
