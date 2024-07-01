import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/payment_setting_model.dart';
import 'package:cabme_driver/model/ride_model.dart';
import 'package:cabme_driver/model/trip_ride_details_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import '../themes/button_them.dart';
import '../themes/constant_colors.dart';

class TripHistoryScreenController extends GetxController {
  var isLoading = true.obs;
  RxString rideType = "".obs;
  RxBool isAddOnsLoading = true.obs;
  RxBool isaddonPricingLoading = true.obs;
  var rideId = "".obs;
  var singleRideDetails = <SingleRideData>[].obs;
  RxString formattedTime = "".obs;
  RxDouble subTotal = 0.0.obs;
  RxDouble price = 500.00.obs;

  RxString allowCod = "no".obs;
  // final addonTaxPricing = {}.obs;

  RxString paymentMethodType = "".obs;
  RxString pricingId = "".obs;

  // RxSet<int> selectedAddon = <int>{}.obs;
  RxInt selectedAddon = (-1).obs; // Use an integer to store the selected index
  var paymentSettingModel = PaymentSettingModel().obs;
  RxString paymentMethodId = "".obs;
  RxBool cash = false.obs;
  RxBool razorPay = false.obs;

  RxString transactionId = "".obs;
  RxString transactionStatus = "".obs;

  var isButtonEnabled = true.obs;

  @override
  void onInit() {
    getArgument();
    getRideDetails();
    paymentSettingModel.value = Constant.getPaymentSetting();
    super.onInit();
  }

  // getArgument() async {
  //   dynamic argumentData = Get.arguments;
  //   debugPrint("argumentData:$argumentData");
  //   if (argumentData != null) {
  //     rideId.value = argumentData["rideId"];
  //   }
  // }

  var data = RideData().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["rideData"];

      // subTotalAmount.value = double.parse(data.value.montant!);
      // tipAmount.value = data.value.tipAmount != "null" && data.value.tipAmount!.isNotEmpty ? double.parse(data.value.tipAmount.toString()) : 0.0;
      // // taxAmount.value = double.parse(data.value.tax!);
      // discountAmount.value = data.value.discount != "null" ? double.parse(data.value.discount!) : 0.0;
      // for (var i = 0; i < data.value.taxModel!.length; i++) {
      //   if (data.value.taxModel![i].statut == 'yes') {
      //     if (data.value.taxModel![i].type == "Fixed") {
      //       taxAmount.value += double.parse(data.value.taxModel![i].value.toString());
      //     } else {
      //       taxAmount.value += ((subTotalAmount.value - discountAmount.value) * double.parse(data.value.taxModel![i].value!.toString())) / 100;
      //     }
      //   }
      // }
    }
  }

  Future<dynamic> getRideDetails() async {
    try {
      debugPrint("rideId.value:${rideId.value}");
      Map<String, dynamic> bodyParams = {'id_user_app': data.value.idUserApp, 'ride_id': data.value.id};
      final response = await http.post(Uri.parse(API.getUserRidesDetails), headers: API.header, body: jsonEncode(bodyParams));
      debugPrint(response.toString());
      Map<String, dynamic> responseBody = json.decode(response.body);

      debugPrint("=====$responseBody");

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;

        SingleRideDetailsModel model = SingleRideDetailsModel.fromJson(responseBody);

        singleRideDetails.value = model.data!;

        rideType.value = singleRideDetails[0].rideType.toString();
        // subTotal.value = (double.parse(singleRideDetails[0].carPrice!) - double.parse(singleRideDetails[0].discount!));

        //DateTime heureRetour = DateFormat("HH:mm:ss").parse(singleRideDetails[0].heureRetour.toString());
        if (singleRideDetails[0].statut == "completed") {
          String timeString = "00:00:23";
          List<String> parts = timeString.split(':');
          int hours = int.parse(parts[0]);
          int minutes = int.parse(parts[1]);
          int seconds = int.parse(parts[2]);
          Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

          // Convert the duration to minutes
          formattedTime.value = duration.inMinutes.toString();
        }

        //formattedTime.value = DateFormat('HH:mm').format(heureRetour);
      } else if (response.statusCode == 200 && responseBody['success'] == "Failed") {
        singleRideDetails.value = [];
        isLoading.value = false;
      } else {
        isLoading.value = false;
        ShowToastDialog.showToast('Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      log('FireStoreUtils.getCurrencys Parse error $e');
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
