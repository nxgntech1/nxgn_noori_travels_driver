import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/dash_board_controller.dart';
import 'package:cabme_driver/controller/new_ride_controller.dart';
import 'package:cabme_driver/model/ride_model.dart';
import 'package:cabme_driver/page/completed/trip_history_screen.dart';
import 'package:cabme_driver/page/route_view_screen/route_view_screen.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../service/api.dart';
import '../../themes/responsive.dart';
import '../../themes/text_field_them.dart';
import 'booking_confirmation/booking_confirmation.dart';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({super.key});

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  final controllerDashBoard = Get.put(DashBoardController());
  Timer? locationUpdateTimer;

  // Future<void> requestPermissions() async {
  //   var status = await Permission.locationWhenInUse.request();
  //   if (status.isGranted) {
  //     // Request background location permission for Android 10+
  //     if (await Permission.locationAlways.isDenied) {
  //       status = await Permission.locationAlways.request();
  //     }
  //   }

  //   if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  @override
  void initState() {
    // controllerDashBoard.getdriverLocationUpdate();
    // startLocationUpdates();
    // requestPermissions().then((_) {
    //   startLocationUpdates();
    // });
  }

  // void startBackgroundLocationUpdates() async {
  //   final hasPermissions = await FlutterBackground.initialize();
  //   if (hasPermissions) {
  //     await FlutterBackground.enableBackgroundExecution();
  //     // Now you can start location updates
  //     startLocationUpdates();
  //   }
  // }

  // void startLocationUpdates() {
  //   locationUpdateTimer = Timer.periodic(const Duration(seconds: 20), (Timer timer) async {
  //     try {
  //       LocationData location = await Location().getLocation();
  //       debugPrint("Location Update: Latitude ${location.latitude}, Longitude ${location.longitude}");
  //       // await getdriverLocationUpdate(location.latitude.toString(), location.longitude.toString());
  //       // await getdriverLocationUpdate("17.4286566", "78.5489204");
  //     } catch (e) {
  //       debugPrint('Error in location update: $e');
  //     }
  //   });
  // }

  // Future<dynamic> getdriverLocationUpdate(String latitude, String longitude) async {
  //   try {
  //     Map<String, dynamic> bodyParams = {
  //       'id_driver': Preferences.getInt(Preferences.userId),
  //       'latitude': latitude,
  //       'longitude': longitude,
  //     };
  //     debugPrint("bodyparams data :  ${bodyParams.toString()}");
  //     final response = await http.post(Uri.parse(API.getdriverLocationUpdate), headers: API.header, body: jsonEncode(bodyParams));

  //     Map<String, dynamic> responseBody = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       return responseBody;
  //     }
  //   } on TimeoutException catch (e) {
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on SocketException catch (e) {
  //     ShowToastDialog.showToast(e.message.toString());
  //   } on Error catch (e) {
  //     ShowToastDialog.showToast(e.toString());
  //   } catch (e) {
  //     ShowToastDialog.showToast(e.toString());
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("new change");

    debugPrint("Accesstoken new ${Preferences.getString(Preferences.accesstoken)}");
    return GetX<NewRideController>(
      init: NewRideController(),
      builder: (controller) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: ConstantColors.background,
            body: RefreshIndicator(
              onRefresh: () => controller.getNewRide(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    if (double.parse(controller.userModel.value.userData!.amount.toString()) < double.parse(Constant.minimumWalletBalance!))
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ConstantColors.primary),
                        child: Text(
                          "${"Your wallet balance must be".tr} ${Constant().amountShow(amount: Constant.minimumWalletBalance!.toString())} ${"to get ride.".tr}",
                        ),
                      ),
                    Expanded(
                      child: controller.isLoading.value
                          ? Constant.loader()
                          : controller.rideList.isEmpty
                              ? SingleChildScrollView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                      height: Get.height,
                                      child: Constant.emptyView("You have not been assigned any trip yet. \n Please change your status to Online.".tr)))
                              : ListView.builder(
                                  itemCount: controller.rideList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return newRideWidgets(context, controller.rideList[index], controller);
                                  }),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget newRideWidgets(BuildContext context, RideData data, NewRideController controller) {
    return InkWell(
      onTap: () async {
        if (data.statut == "Completed") {
          var isDone = await Get.to(const TripHistoryScreen(), arguments: {
            "rideData": data,
          });
          if (isDone != null) {
            controller.getNewRide();
          }
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        (data.vehicleImage != null && data.vehicleImage != "null")
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  // imageUrl: controller.data.value.vehicleImageid.toString(),
                                  imageUrl: data.vehicleImage.toString(),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Constant.loader(),
                                  errorWidget: (context, url, error) => Image.asset(
                                    height: 50,
                                    width: 50,
                                    "assets/images/appIcon.png",
                                  ),
                                ),
                              )
                            : Image.asset(
                                height: 50,
                                width: 50,
                                "assets/images/appIcon.png",
                              ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(data.model.toString(), style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(data.numberplate.toString(), style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2), // Add desired padding here
                              decoration: BoxDecoration(
                                // color: ConstantColors.primary, // Background color
                                borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
                              ),
                              child: buildStatusText(data.statut.toString()),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                              child: Text(
                            "Package:",
                            style: TextStyle(fontSize: 14),
                          )),
                          Expanded(
                            child: Text(
                              data.bookingtype.toString(),
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              "assets/icons/location.png",
                              height: 20,
                            ),
                            Image.asset(
                              "assets/icons/line.png",
                              height: 30,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            data.departName.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Divider(),
                      ],
                    ),

                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.stops ?? [].length,
                        itemBuilder: (context, int index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    String.fromCharCode(index + 65),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/icons/line.png",
                                    height: 30,
                                    color: ConstantColors.hintTextColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.stops![index].location.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                    // const Text("sample"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/icons/round.png",
                          height: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            data.destinationName.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          Constant.currency.toString(),
                                          style: TextStyle(
                                            color: ConstantColors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(Constant().amountShow(amount: data.montant.toString()),
                                            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/ic_distance.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                              "${double.parse(data.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${Constant.distanceUnit}",
                                              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/time.png',
                                          height: 22,
                                          width: 22,
                                          color: ConstantColors.yellow,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(data.duree!.replaceAll('hours', 'hrs').toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(top: 8.0),
                                        //   child: TextScroll(data.duree.toString(),
                                        //       mode: TextScrollMode.bouncing,
                                        //       pauseBetween: const Duration(seconds: 2),
                                        //       style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (data.statut != "Completed")
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () async {
                                    var isDone = await Get.to(const TripHistoryScreen(), arguments: {
                                      "rideData": data,
                                    });
                                    if (isDone != null) {
                                      controller.getNewRide();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      child: Column(
                                        children: [
                                          Icon(Icons.remove_red_eye_outlined, color: ConstantColors.primary),
                                          // Text(
                                          //   Constant.currency.toString(),
                                          //   style: TextStyle(
                                          //     color: ConstantColors.yellow,
                                          //     fontWeight: FontWeight.bold,
                                          //     fontSize: 20,
                                          //   ),
                                          // ),
                                          const Text("View Details", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () async {
                                    var argumentData = {'type': data.statut, 'data': data};
                                    if (Constant.mapType == "inappmap//") {
                                      Get.to(const RouteViewScreen(), arguments: argumentData);
                                    } else {
                                      String googleUrl = "";
                                      await controller.getCurrentLocation();
                                      if (data.statut == "Start Trip") {
                                        googleUrl =
                                            'https://www.google.com/maps/dir/?api=1&origin=${double.parse(controller.driverLatitude.toString())},${double.parse(controller.driverLongitude.toString())}&destination=${double.parse(data.latitudeDepart.toString())},${double.parse(data.longitudeDepart.toString())}';
                                      } else {
                                        googleUrl =
                                            'https://www.google.com/maps/dir/?api=1&origin=${double.parse(controller.driverLatitude.toString())},${double.parse(controller.driverLongitude.toString())}&destination=${double.parse(data.latitudeArrivee.toString())},${double.parse(data.longitudeArrivee.toString())}';
                                      }
                                      if (googleUrl != await canLaunch(googleUrl)) {
                                        await launch(
                                          googleUrl,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black12,
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/icons/ic_distance.png',
                                            height: 22,
                                            width: 22,
                                            color: ConstantColors.yellow,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text("Get Directions", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          (data.photoPath != null && data.photoPath != "null")
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: data.photoPath.toString(),
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Image.asset(
                                      "assets/images/appIcon.png",
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  height: 50,
                                  width: 50,
                                  "assets/images/appIcon.png",
                                ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${data.consumerName}', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 5),
                                    Text(data.rideRequiredOnDate.toString(), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 5),
                                    Text('${data.phone}', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                  ],
                                )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: InkWell(
                                  onTap: () {
                                    Constant.makePhoneCall(data.phone.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0), // Adjust the padding as needed
                                    decoration: const BoxDecoration(
                                      // color: ConstantColors.primary, // Background color
                                      shape: BoxShape.circle, // Makes the container circular
                                    ),
                                    child: Icon(
                                      Icons.call,
                                      color: ConstantColors.primary, // Icon color
                                      size: 24.0, // Icon size
                                    ),
                                  ),
                                ),
                              ),
                              // Text(data.dateRetour.toString(), style: const TextStyle(color: Colors.black26, fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Visibility(
                    //   visible: data.statut == "completed" ? true : false,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 10.0),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //             child: ButtonThem.buildButton(context,
                    //                 btnHeight: 40,
                    //                 title: data.statutPaiement == "yes" ? "paid".tr : "Not paid".tr,
                    //                 btnColor: data.statutPaiement == "yes" ? Colors.green : ConstantColors.primary,
                    //                 txtColor: Colors.white, onPress: () {
                    //           // if (data.payment == "Cash") {
                    //           //   controller.conformPaymentByCache(data.id.toString()).then((value) {
                    //           //     if (value != null) {
                    //           //       showDialog(
                    //           //           context: context,
                    //           //           builder: (BuildContext context) {
                    //           //             return CustomDialogBox(
                    //           //               title: "Payment by cash",
                    //           //               descriptions: "Payment collected successfully",
                    //           //               text: "Ok",
                    //           //               onPress: () {
                    //           //                 Get.back();
                    //           //                 controller.getCompletedRide();
                    //           //               },
                    //           //               img: Image.asset('assets/images/green_checked.png'),
                    //           //             );
                    //           //           });
                    //           //     }
                    //           //   });
                    //           // } else {}
                    //         })),
                    //         if (data.existingUserId.toString() != "null")
                    //           Expanded(
                    //             child: Padding(
                    //                 padding: const EdgeInsets.only(left: 10),
                    //                 child: ButtonThem.buildBorderButton(
                    //                   context,
                    //                   title: 'add_review'.tr,
                    //                   btnWidthRatio: 0.8,
                    //                   btnHeight: 40,
                    //                   btnColor: Colors.white,
                    //                   txtColor: ConstantColors.primary,
                    //                   btnBorderColor: ConstantColors.primary,
                    //                   onPress: () async {
                    //                     Get.to(const AddReviewScreen(), arguments: {
                    //                       'rideData': data,
                    //                     });
                    //                   },
                    //                 )),
                    //           ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Visibility(
                            visible: true,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: data.payment!,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: Colors.white,
                                  txtColor: Colors.black.withOpacity(0.60),
                                  btnBorderColor: Colors.black.withOpacity(0.20),
                                  onPress: () async {
                                    // buildShowBottomSheet(context, data, controller);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "Start Trip" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'Arrived'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    await controller.getCurrentLocation();
                                    Map<String, String> bodyParams = {
                                      "id_ride": data.id.toString(),
                                      "id_user": data.userId.toString(),
                                      "driver_lat": controller.driverLatitude.toString(),
                                      "driver_lon": controller.driverLongitude.toString()
                                    };

                                    dynamic responceflag = await controller.changestatusArrived(bodyParams);
                                    if (responceflag == 1) {
                                      controller.rideStatus.value = "On Ride";
                                    }
                                    // if (responceflag == 1) {
                                    //   String googleUrl =
                                    //       'https://www.google.com/maps/dir/?api=1&origin=${controller.driverLatitude},${controller.driverLongitude}&destination=${double.parse(data.latitudeDepart!)},${double.parse(data.longitudeDepart!)}';
                                    //   // 'https://www.google.com/maps/dir/?api=1&origin=17.2402684,78.4268102&destination=17.2402684,78.4268102';
                                    //   if (await canLaunch(googleUrl)) {
                                    //     await launch(
                                    //       googleUrl,
                                    //     );
                                    //   } else {
                                    //     throw 'Could not open the map.';
                                    //   }
                                    // }
                                  },
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: data.statut == "vehicle assigned" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'Start Trip'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    // var sLat = data.latitudeDepart;
                                    // var sLong = data.longitudeDepart;
                                    if (true) {
                                      buildOdoMeterStartBottomSheet(context, controller, data);
                                    }
                                    /* URL : https://nadmin.nxgnapp.com/api/v1/changestatus-starttrip
                                      {"id_ride":"171","id_user":"1","driver_lat":"17.35345345","driver_lon":"78.23423423","distance_to_pickup":"25"}
                                      Note: navigate to google maps from driver location to departure location */
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "Arrived" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'Start ride'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    await buildOTPBottomSheet(context, controller, data);

                                    /*URL : https://nadmin.nxgnapp.com/api/v1/changestatus-arrived
                                    Request : {"id_ride":"171","id_user":"1","driver_lat":"17.35345345","driver_lon":"78.23423423"} */
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "On Ride" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'Complete'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    buildOdoMeterEndBottomSheet(context, controller, data);
                                    // Map<String, String> bodyParams = {
                                    //   "id_ride": data.id.toString(),
                                    //   "id_user": data.userId.toString(),
                                    //   "driver_lat": controller.driverLatitude.toString(),
                                    //   "driver_lon": controller.driverLongitude.toString()
                                    // };
                                    // dynamic responceflag = await controller.changestatusCompleted(bodyParams);
                                    // if (responceflag == 1) {
                                    //   if (data.payment == "Cash") {
                                    //     controller.rideStatus.value = "completed";
                                    //     showDialog(
                                    //       barrierDismissible: false,
                                    //       context: context,
                                    //       builder: (BuildContext context) {
                                    //         return AlertDialog(
                                    //           title: Text("Collect Cash - ${data.montant}"),
                                    //           content: Text("Please collect cash and click on collected".tr),
                                    //           actions: [
                                    //             TextButton(
                                    //               child: const Text("Collected"),
                                    //               onPressed: () async {
                                    //                 Map<String, String> bodyParams = {
                                    //                   "id_ride": data.id.toString(),
                                    //                   "id_user_app": data.userId.toString(),
                                    //                 };
                                    //                 dynamic responceflag = await controller.cashCollected(bodyParams);
                                    //                 if (responceflag == 1) {
                                    //                   Get.back();
                                    //                 }
                                    //               },
                                    //             ),
                                    //           ],
                                    //         );
                                    //       },
                                    //     );
                                    //   } else {
                                    //     throw 'No cash';
                                    //   }
                                    // }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data.statut == "Completed" ? true : false,
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'completed'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: Colors.green,
                                  txtColor: Colors.white,
                                  onPress: () async {
                                    /*URL : https://nadmin.nxgnapp.com/api/v1/changestatus-completed
                                      {"id_ride":"171","id_user":"1","driver_lat":"17.35345345","driver_lon":"78.23423423"} */
                                    // controller.rideStatus.value = "completed";
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Visibility(
                          //   visible: data.statut == "completed" ? true : false,
                          //   child: Expanded(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(bottom: 5, left: 10),
                          //       child: ButtonThem.buildButton(
                          //         context,
                          //         title: 'Cash Received'.tr,
                          //         btnHeight: 45,
                          //         btnWidthRatio: 0.8,
                          //         btnColor: ConstantColors.primary,
                          //         txtColor: Colors.black,
                          //         onPress: () async {
                          //           /*Cash Received (only for cash payments)
                          //           URL : https://nadmin.nxgnapp.com/api/v1/cash-paid-request
                          //           Request : {"id_ride":"171","id_user_app":"1"}*/
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // Visibility(
                          //   visible: data.statut == "Arrived" ? true : false,
                          //   child: Expanded(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(bottom: 5, left: 10),
                          //       child: ButtonThem.buildButton(
                          //         context,
                          //         title: 'Arrived'.tr,
                          //         btnHeight: 45,
                          //         btnWidthRatio: 0.8,
                          //         btnColor: ConstantColors.primary,
                          //         txtColor: Colors.black,
                          //         onPress: () async {
                          //           Map<String, String> bodyParams = {
                          //             'id_ride': data.id.toString(),
                          //             'id_user': data.idUserApp.toString(),
                          //             'driver_lat': data.latitudeDepart.toString(),
                          //             'driver_lon': data.longitudeDepart.toString(),
                          //           };

                          //           controller.changestatusStarttrip(bodyParams).then((value) {
                          //             if (value != null) {
                          //               data.statut = "On ride";
                          //               Get.back();
                          //             }
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // // Visibility(
                          // //   visible: data.statut == "On ride" ? true : false,
                          // //   child: Expanded(
                          // //     child: Padding(
                          // //       padding: const EdgeInsets.only(bottom: 5, left: 10),
                          // //       child: ButtonThem.buildButton(
                          // //         context,
                          // //         title: 'on ride'.tr,
                          // //         btnHeight: 45,
                          // //         btnWidthRatio: 0.8,
                          // //         btnColor: ConstantColors.primary,
                          // //         txtColor: Colors.black,
                          // //         onPress: () async {
                          // //           showDialog(
                          // //             barrierColor: const Color.fromARGB(66, 20, 14, 14),
                          // //             context: context,
                          // //             builder: (context) {
                          // //               return CustomAlertDialog(
                          // //                 title: "Do you want to on ride this ride?".tr,
                          // //                 negativeButtonText: 'No'.tr,
                          // //                 positiveButtonText: 'Yes'.tr,
                          // //                 onPressNegative: () {
                          // //                   Get.back();
                          // //                 },
                          // //                 onPressPositive: () {
                          // //                   Get.back();

                          // //                   if (Constant.rideOtp.toString() != 'yes' || data.rideType! == 'driver') {
                          // //                     Map<String, String> bodyParams = {
                          // //                       'id_ride': data.id.toString(),
                          // //                       'id_user': data.idUserApp.toString(),
                          // //                       'use_name': '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                          // //                       'from_id': Preferences.getInt(Preferences.userId).toString(),
                          // //                     };
                          // //                     controller.setOnRideRequest(bodyParams).then((value) {
                          // //                       if (value != null) {
                          // //                         Get.back();
                          // //                         showDialog(
                          // //                             context: context,
                          // //                             builder: (BuildContext context) {
                          // //                               return CustomDialogBox(
                          // //                                 title: "On ride Successfully".tr,
                          // //                                 descriptions: "Ride Successfully On ride.".tr,
                          // //                                 text: "Ok".tr,
                          // //                                 onPress: () {
                          // //                                   controller.getNewRide();
                          // //                                 },
                          // //                                 img: Image.asset('assets/images/green_checked.png'),
                          // //                               );
                          // //                             });
                          // //                       }
                          // //                     });
                          // //                   } else {
                          // //                     controller.otpController = TextEditingController();
                          // //                     showDialog(
                          // //                       barrierColor: Colors.black26,
                          // //                       context: context,
                          // //                       builder: (context) {
                          // //                         return Dialog(
                          // //                           shape: RoundedRectangleBorder(
                          // //                             borderRadius: BorderRadius.circular(20),
                          // //                           ),
                          // //                           elevation: 0,
                          // //                           child: Container(
                          // //                             height: 200,
                          // //                             padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 20),
                          // //                             decoration: BoxDecoration(
                          // //                                 shape: BoxShape.rectangle,
                          // //                                 color: Colors.white,
                          // //                                 borderRadius: BorderRadius.circular(20),
                          // //                                 boxShadow: const [
                          // //                                   BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                          // //                                 ]),
                          // //                             child: Column(
                          // //                               children: [
                          // //                                 Text(
                          // //                                   "Enter OTP".tr,
                          // //                                   style: TextStyle(color: Colors.black.withOpacity(0.60)),
                          // //                                 ),
                          // //                                 Pinput(
                          // //                                   controller: controller.otpController,
                          // //                                   defaultPinTheme: PinTheme(
                          // //                                     height: 50,
                          // //                                     width: 50,
                          // //                                     textStyle: const TextStyle(
                          // //                                         letterSpacing: 0.60, fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                          // //                                     // margin: EdgeInsets.all(10),
                          // //                                     decoration: BoxDecoration(
                          // //                                       borderRadius: BorderRadius.circular(10),
                          // //                                       shape: BoxShape.rectangle,
                          // //                                       color: Colors.white,
                          // //                                       border: Border.all(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                          // //                                     ),
                          // //                                   ),
                          // //                                   keyboardType: TextInputType.phone,
                          // //                                   textInputAction: TextInputAction.done,
                          // //                                   length: 6,
                          // //                                 ),
                          // //                                 const SizedBox(
                          // //                                   height: 8,
                          // //                                 ),
                          // //                                 Row(
                          // //                                   children: [
                          // //                                     Expanded(
                          // //                                       child: ButtonThem.buildButton(
                          // //                                         context,
                          // //                                         title: 'done'.tr,
                          // //                                         btnHeight: 45,
                          // //                                         btnWidthRatio: 0.8,
                          // //                                         btnColor: ConstantColors.primary,
                          // //                                         txtColor: Colors.white,
                          // //                                         onPress: () {
                          // //                                           if (controller.otpController.text.toString().length == 6) {
                          // //                                             controller
                          // //                                                 .verifyOTP(
                          // //                                               userId: data.idUserApp!.toString(),
                          // //                                               rideId: data.id!.toString(),
                          // //                                             )
                          // //                                                 .then((value) {
                          // //                                               if (value != null && value['success'] == "success") {
                          // //                                                 Map<String, String> bodyParams = {
                          // //                                                   'id_ride': data.id.toString(),
                          // //                                                   'id_user': data.idUserApp.toString(),
                          // //                                                   'use_name': '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                          // //                                                   'from_id': Preferences.getInt(Preferences.userId).toString(),
                          // //                                                 };
                          // //                                                 controller.setOnRideRequest(bodyParams).then((value) {
                          // //                                                   if (value != null) {
                          // //                                                     Get.back();
                          // //                                                     showDialog(
                          // //                                                         context: context,
                          // //                                                         builder: (BuildContext context) {
                          // //                                                           return CustomDialogBox(
                          // //                                                             title: "On ride Successfully".tr,
                          // //                                                             descriptions: "Ride Successfully On ride.".tr,
                          // //                                                             text: "Ok".tr,
                          // //                                                             onPress: () {
                          // //                                                               Get.back();
                          // //                                                               controller.getNewRide();
                          // //                                                             },
                          // //                                                             img: Image.asset('assets/images/green_checked.png'),
                          // //                                                           );
                          // //                                                         });
                          // //                                                   }
                          // //                                                 });
                          // //                                               }
                          // //                                             });
                          // //                                           } else {
                          // //                                             ShowToastDialog.showToast('Please Enter OTP'.tr);
                          // //                                           }
                          // //                                         },
                          // //                                       ),
                          // //                                     ),
                          // //                                     const SizedBox(
                          // //                                       width: 8,
                          // //                                     ),
                          // //                                     Expanded(
                          // //                                       child: ButtonThem.buildBorderButton(
                          // //                                         context,
                          // //                                         title: 'cancel'.tr,
                          // //                                         btnHeight: 45,
                          // //                                         btnWidthRatio: 0.8,
                          // //                                         btnColor: Colors.white,
                          // //                                         txtColor: Colors.black.withOpacity(0.60),
                          // //                                         btnBorderColor: Colors.black.withOpacity(0.20),
                          // //                                         onPress: () {
                          // //                                           Get.back();
                          // //                                         },
                          // //                                       ),
                          // //                                     )
                          // //                                   ],
                          // //                                 ),
                          // //                               ],
                          // //                             ),
                          // //                           ),
                          // //                         );
                          // //                       },
                          // //                     );
                          // //                   }
                          // //                   // if (data.carDriverConfirmed == 1) {
                          // //                   //
                          // //                   // } else if (data.carDriverConfirmed == 2) {
                          // //                   //   Get.back();
                          // //                   //   ShowToastDialog.showToast("Customer decline the confirmation of driver and car information.");
                          // //                   // } else if (data.carDriverConfirmed == 0) {
                          // //                   //   Get.back();
                          // //                   //   ShowToastDialog.showToast("Customer needs to verify driver and car before you can start trip.");
                          // //                   // }
                          // //                 },
                          // //               );
                          // //             },
                          // //           );
                          // //         },
                          // //       ),
                          // //     ),
                          // //   ),
                          // // ),
                          // Visibility(
                          //   visible: data.statut == "cancelled" ? true : false,
                          //   child: Expanded(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(bottom: 5),
                          //       child: ButtonThem.buildBorderButton(
                          //         context,
                          //         title: 'cancelled'.tr,
                          //         btnHeight: 45,
                          //         btnWidthRatio: 0.8,
                          //         btnColor: Colors.white,
                          //         txtColor: Colors.black.withOpacity(0.60),
                          //         btnBorderColor: Colors.black.withOpacity(0.20),
                          //         onPress: () async {},
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Visibility(
                          //   visible: data.statut == "completed" ? true : false,
                          //   child: Expanded(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(bottom: 5),
                          //       child: ButtonThem.buildBorderButton(
                          //         context,
                          //         title: 'completed'.tr,
                          //         btnHeight: 45,
                          //         btnWidthRatio: 0.8,
                          //         btnColor: Colors.white,
                          //         txtColor: Colors.black.withOpacity(0.60),
                          //         btnBorderColor: Colors.black.withOpacity(0.20),
                          //         onPress: () async {},
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Visibility(
                          //   visible: data.statut == "On Ride" ? true : false,
                          //   child: Expanded(
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(bottom: 5),
                          //       child: ButtonThem.buildBorderButton(
                          //         context,
                          //         title: 'On Ride'.tr,
                          //         btnHeight: 45,
                          //         btnWidthRatio: 0.8,
                          //         btnColor: Colors.white,
                          //         txtColor: Colors.black.withOpacity(0.60),
                          //         btnBorderColor: Colors.black.withOpacity(0.20),
                          //         onPress: () async {
                          //           Map<String, String> bodyParams = {
                          //             'id_ride': data.id.toString(),
                          //             'id_user': data.idUserApp.toString(),
                          //             'driver_lat': data.latitudeDepart.toString(),
                          //             'driver_lon': data.longitudeDepart.toString(),
                          //           };

                          //           controller.changestatusOnride(bodyParams).then((value) {
                          //             if (value != null) {
                          //               data.statut = "completed";
                          //               // Get.back();
                          //               // showDialog(
                          //               //     context: context,
                          //               //     builder: (BuildContext context) {
                          //               //       return CustomDialogBox(
                          //               //         title: "Confirmed Successfully".tr,
                          //               //         descriptions: "Ride Successfully confirmed.".tr,
                          //               //         text: "Ok".tr,
                          //               //         onPress: () {
                          //               //           Get.back();
                          //               //           controller.getNewRide();
                          //               //         },
                          //               //         img: Image.asset('assets/images/green_checked.png'),
                          //               //       );
                          //               //     });
                          //             }
                          //           });
                          //           String googleUrl =
                          //               'https://www.google.com/maps/dir/?api=1&origin=${double.parse(data.latitudeArrivee.toString())},${double.parse(data.longitudeArrivee.toString())}&destination=${double.parse(data.latitudeDepart.toString())},${double.parse(data.longitudeDepart.toString())}';
                          //           // https://www.google.com/maps/search/?api=1&query=${double.parse(data.latitudeArrivee.toString())},${double.parse(data.longitudeArrivee.toString())}
                          //           if (await canLaunch(googleUrl)) {
                          //             await launch(
                          //               googleUrl,
                          //               // forceWebView: true,
                          //               // enableJavaScript: true,
                          //               // enableDomStorage: true,
                          //             );
                          //           } else {
                          //             throw 'Could not open the map.';
                          //           }
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // // Visibility(
                          // //   visible: data.statut == "on ride" ? true : false,
                          // //   child: Expanded(
                          // //     child: Padding(
                          // //       padding: const EdgeInsets.only(bottom: 5, left: 10),
                          // //       child: ButtonThem.buildButton(
                          // //         context,
                          // //         title: 'COMPLETE'.tr,
                          // //         btnHeight: 45,
                          // //         btnWidthRatio: 0.8,
                          // //         btnColor: ConstantColors.primary,
                          // //         txtColor: Colors.black,
                          // //         onPress: () async {
                          // //           showDialog(
                          // //             barrierColor: Colors.black26,
                          // //             context: context,
                          // //             builder: (context) {
                          // //               return CustomAlertDialog(
                          // //                 title: "Do you want to complete this ride?".tr,
                          // //                 onPressNegative: () {
                          // //                   Get.back();
                          // //                 },
                          // //                 negativeButtonText: 'No'.tr,
                          // //                 positiveButtonText: 'Yes'.tr,
                          // //                 onPressPositive: () {
                          // //                   Map<String, String> bodyParams = {
                          // //                     'id_ride': data.id.toString(),
                          // //                     'id_user': data.idUserApp.toString(),
                          // //                     'driver_name': '${data.prenomConducteur.toString()} ${data.nomConducteur.toString()}',
                          // //                     'from_id': Preferences.getInt(Preferences.userId).toString(),
                          // //                   };
                          // //                   controller.setCompletedRequest(bodyParams, data).then((value) {
                          // //                     if (value != null) {
                          // //                       Get.back();
                          // //                       showDialog(
                          // //                           context: context,
                          // //                           builder: (BuildContext context) {
                          // //                             return CustomDialogBox(
                          // //                               title: "Completed Successfully".tr,
                          // //                               descriptions: "Ride Successfully completed.".tr,
                          // //                               text: "Ok".tr,
                          // //                               onPress: () {
                          // //                                 Get.back();
                          // //                                 controller.getNewRide();
                          // //                               },
                          // //                               img: Image.asset('assets/images/green_checked.png'),
                          // //                             );
                          // //                           });
                          // //                     }
                          // //                   });
                          // //                 },
                          // //               );
                          // //             },
                          // //           );
                          // //         },
                          // //       ),
                          // //     ),
                          // //   ),
                          // // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Positioned(
          //     right: 0,
          //     child: Image.asset(
          //       data.statut == "vehicle assigned"
          //           ? 'assets/images/new.png'
          //           : data.statut == "confirmed"
          //               ? 'assets/images/conformed.png'
          //               : data.statut == "on ride"
          //                   ? 'assets/images/onride.png'
          //                   : data.statut == "completed"
          //                       ? 'assets/images/completed.png'
          //                       : 'assets/images/rejected.png',
          //       height: 120,
          //       width: 120,
          //     )),
        ],
      ),
    );
  }

  final resonController = TextEditingController();

  // buildShowBottomSheet(BuildContext context, RideData data, NewRideController controller) {
  Widget buildStatusText(String statut) {
    if (statut == "vehicle assigned") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: ConstantColors.primary, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "Vehicle assigned",
          style: TextStyle(
            fontSize: 13,
            // backgroundColor: ConstantColors.primary,
            color: Colors.white,
          ),
        ),
      );
    } else if (statut == "Start Trip") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: ConstantColors.primary, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "Start Trip",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    } else if (statut == "Arrived") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: Colors.yellow, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "Arrived",
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
      );
    } else if (statut == "On Ride") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: Colors.red[400], // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "On ride",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: Colors.green[400], // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "Completed",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}

buildOdoMeterStartBottomSheet(BuildContext context, NewRideController controller, RideData data) {
  controller.odoStartController = TextEditingController();
  return showModalBottomSheet(
      //isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              margin: const EdgeInsets.all(10),
              //height: Responsive.height(25, context),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter odometer reading to start the trip".tr,
                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.60)),
                  ),
                  TextFieldThem.boxBuildTextFieldWithDigitsOnly(
                    hintText: ''.tr,
                    controller: controller.odoStartController,
                    textInputType: TextInputType.number,
                    maxLength: 20,
                    contentPadding: EdgeInsets.zero,
                    suffixIconOrImage: "assets/icons/odometer.png",
                    validators: (String? value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'required'.tr;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonThem.buildButton(
                    context,
                    title: 'Start Trip'.tr,
                    btnHeight: 45,
                    //btnWidthRatio: 0.8,
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: () async {
                      if (controller.odoStartController.text.isNotEmpty) {
                        await controller.getCurrentLocation();
                        var distanceDriverToUser = await controller.getDistanceFromDrivertoUser(data.latitudeDepart, data.longitudeDepart);
                        Map<String, String> bodyParams = {
                          "id_ride": data.id.toString(),
                          "id_user": data.userId.toString(),
                          "driver_lat": controller.driverLatitude.toString(),
                          "driver_lon": controller.driverLongitude.toString(),
                          "distance_to_pickup": distanceDriverToUser.toString(),
                          "odometer_start_reading": controller.odoStartController.text.toString(),
                        };

                        dynamic responceflag = await controller.changestatusStarttrip(bodyParams);

                        if (responceflag == 1) {
                          // controller.rideStatus.value = "Start Trip";
                          // buildOdoMeterAfterOtpBottomSheet(context, controller, data);
                          Get.back();
                          String googleUrl =
                              'https://www.google.com/maps/dir/?api=1&origin=${controller.driverLatitude},${controller.driverLongitude}&destination=${double.parse(data.latitudeDepart!)},${double.parse(data.longitudeDepart!)}';
                          // 'https://www.google.com/maps/dir/?api=1&origin=17.2402684,78.4268102&destination=17.2402684,78.4268102';
                          if (await canLaunch(googleUrl)) {
                            Get.back();
                            await launch(
                              googleUrl,
                            );
                          } else {
                            throw 'Could not open the map.';
                          }
                        }
                      } else {
                        ShowToastDialog.showToast("please enter odometer reading");
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        );
      });
}

buildOdoMeterAfterOtpBottomSheet(BuildContext context, NewRideController controller, RideData data) {
  controller.odoStartController = TextEditingController();
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              margin: const EdgeInsets.all(10),
              //height: Responsive.height(25, context),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter odometer reading".tr,
                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.60)),
                  ),
                  TextFieldThem.boxBuildTextFieldWithDigitsOnly(
                    hintText: ''.tr,
                    controller: controller.odoSecondOdoController,
                    textInputType: TextInputType.number,
                    maxLength: 20,
                    contentPadding: EdgeInsets.zero,
                    suffixIconOrImage: "assets/icons/odometer.png",
                    validators: (String? value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'required'.tr;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonThem.buildButton(
                    context,
                    title: 'Start Trip'.tr,
                    btnHeight: 45,
                    //btnWidthRatio: 0.8,
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: () async {
                      if (controller.odoSecondOdoController.text.isNotEmpty) {
                        await controller.getCurrentLocation();
                        Map<String, String> bodyParams = {
                          "id_ride": data.id.toString(),
                          "id_user": data.userId.toString(),
                          "odometer_arrival_reading": controller.odoSecondOdoController.text.toString(),
                        };

                        dynamic responceflag = await controller.changestatusAfterOtp(bodyParams);

                        if (responceflag == 1) {
                          // controller.rideStatus.value = "Start Trip";
                          controller.rideStatus.value = "completed";
                          Get.back();
                          String googleUrl =
                              'https://www.google.com/maps/dir/?api=1&origin=${controller.driverLatitude},${controller.driverLongitude}&destination=${double.parse(data.latitudeArrivee!)},${double.parse(data.longitudeArrivee!)}';
                          // 'https://www.google.com/maps/dir/?api=1&origin=17.2402684,78.4268102&destination=17.2402684,78.4268102';
                          if (await canLaunch(googleUrl)) {
                            Get.back();
                            await launch(
                              googleUrl,
                            );
                          } else {
                            throw 'Could not open the map.';
                          }
                        }
                      } else {
                        ShowToastDialog.showToast("please enter odometer reading");
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        );
      });
}

buildOdoMeterEndBottomSheet(BuildContext context, NewRideController controller, RideData data) {
  controller.odoEndController = TextEditingController();
  return showModalBottomSheet(
      //isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              margin: const EdgeInsets.all(10),
              //height: Responsive.height(25, context),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter odometer reading to end the trip".tr,
                    style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.60)),
                  ),
                  TextFieldThem.boxBuildTextFieldWithDigitsOnly(
                    hintText: ''.tr,
                    controller: controller.odoEndController,
                    textInputType: TextInputType.number,
                    maxLength: 20,
                    contentPadding: EdgeInsets.zero,
                    suffixIconOrImage: "assets/icons/odometer.png",
                    validators: (String? value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'required'.tr;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonThem.buildButton(
                    context,
                    title: 'End Trip'.tr,
                    btnHeight: 45,
                    //btnWidthRatio: 0.8,
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: () async {
                      if (controller.odoEndController.text.isNotEmpty &&
                          (int.parse(data.odometerStartReading!) < int.parse(controller.odoEndController.text))) {
                        await controller.getCurrentLocation();
                        Map<String, String> bodyParams = {
                          "id_ride": data.id.toString(),
                          "id_user": data.userId.toString(),
                          "driver_lat": controller.driverLatitude.toString(),
                          "driver_lon": controller.driverLongitude.toString(),
                          "odometer_end_reading": controller.odoEndController.text.toString(),
                        };
                        dynamic responceflag = await controller.changestatusCompleted(bodyParams);
                        if (responceflag == 1) {
                          Get.back();
                          if (controller.collectCash == "1") {
                            controller.rideStatus.value = "completed";
                            await buildCashCollectBottomSheet(context, controller, data);
                            // showDialog(
                            //   barrierDismissible: false,
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Text("Collect Cash - ${data.montant}"),
                            //       content: Text("Please collect cash and click on collected".tr),
                            //       actions: [
                            //         TextButton(
                            //           child: const Text("Collected"),
                            //           onPressed: () async {
                            //             Map<String, String> bodyParams = {
                            //               "id_ride": data.id.toString(),
                            //               "id_user_app": data.userId.toString(),
                            //             };
                            //             dynamic responceflag = await controller.cashCollected(bodyParams);
                            //             if (responceflag == 1) {
                            //               Get.back();
                            //             }
                            //           },
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          }
                          Get.to(
                            const BookingConfirmation(),
                            arguments: {
                              "user_id": Preferences.getInt(Preferences.userId).toString(),
                              "car_brandname": data.brand.toString(),
                              "car_modelname": data.brand.toString(),
                              "lat1": data.latitudeDepart.toString(),
                              "lng1": data.longitudeDepart.toString(),
                              "lat2": data.latitudeDepart.toString(),
                              "lng2": data.longitudeDepart.toString(),
                              "depart_name": data.departName.toString(),
                              "destination_name": data.destinationName.toString(),
                              "booking_type": data.bookingtype.toString(),
                              "finalAmount": "₹${data.montant}",
                              "coupon_id": "".toString(),
                              "duration": data.duree.toString(),
                              "distance": data.distance.toString(),
                              "distance_unit": Constant.distanceUnit.toString(),
                              "id_payment_method": data.payment.toString(),
                              "ride_date": data.rideRequiredOnDate.toString(),
                              "ride_time": data.duree.toString(),
                              "bookfor_others_mobileno": data.bookforOthersMobileno.toString(),
                              "bookfor_others_name": "${(data.bookforOthersName != "") ? data.bookforOthersName : data.consumerName}",
                            },
                          );
                        }
                      } else {
                        if (int.parse(controller.odoEndController.text) < int.parse(controller.odoStartController.text)) {
                          ShowToastDialog.showToast("Please enter valid reading");
                        } else {
                          ShowToastDialog.showToast("Please enter valid reading");
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          }),
        );
      });
}

buildCashCollectBottomSheet(BuildContext context, NewRideController controller, RideData data) {
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            //padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            margin: const EdgeInsets.all(10),
            //height: Responsive.height(25, context),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 240,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xff46CA5D), borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        controller.finalAmount,
                        style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${(data.bookforOthersName != "") ? data.bookforOthersName : data.consumerName} to pay in cash",
                        style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: ButtonThem.buildButton(
                    context,
                    title: 'Cash Collected'.tr,
                    btnHeight: 45,
                    //btnWidthRatio: 0.8,
                    btnColor: ConstantColors.primary,
                    txtColor: Colors.white,
                    onPress: () async {
                      Map<String, String> bodyParams = {
                        "id_ride": data.id.toString(),
                        "id_user_app": data.userId.toString(),
                      };
                      dynamic responceflag = await controller.cashCollected(bodyParams);
                      if (responceflag == 1) {
                        Get.back();
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
      });
}

buildOTPBottomSheet(BuildContext context, NewRideController controller, data) {
  controller.otpController = TextEditingController();
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              margin: const EdgeInsets.all(10),
              height: Responsive.height(25, context),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "   Enter OTP to start ride".tr,
                    style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.60)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    controller: controller.otpController,
                    defaultPinTheme: PinTheme(
                      height: 60,
                      width: 60,
                      textStyle: const TextStyle(letterSpacing: 0.80, fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                      // margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    length: 4,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ButtonThem.buildButton(
                      context,
                      title: 'Start Ride'.tr,
                      btnHeight: 45,
                      btnWidthRatio: 0.8,
                      btnColor: ConstantColors.primary,
                      txtColor: Colors.white,
                      onPress: () async {
                        if (controller.otpController.text.toString().length == 4) {
                          await controller.getCurrentLocation();
                          Map<String, String> bodyParams = {
                            "id_ride": data.id.toString(),
                            "id_user": data.userId.toString(),
                            "driver_lat": controller.driverLatitude.toString(),
                            "driver_lon": controller.driverLongitude.toString(),
                            "otp": controller.otpController.text.toString()
                          };

                          dynamic responceflag = await controller.changestatusOnride(bodyParams);

                          if (responceflag == 1) {
                            await buildOdoMeterAfterOtpBottomSheet(context, controller, data);

                            // String googleUrl =
                            //     'https://www.google.com/maps/dir/?api=1&origin=${double.parse(data.latitudeDepart.toString())},${double.parse(data.longitudeDepart.toString())}&destination=${double.parse(data.latitudeArrivee.toString())},${double.parse(data.longitudeArrivee.toString())}';
                            // //'https://www.google.com/maps/dir/?api=1&origin=17.4365738,78.3670849&destination=17.2402684,78.4268102';
                            // if (await canLaunch(googleUrl)) {
                            //   await launch(
                            //     googleUrl,
                            //     // forceWebView: true,
                            //     // enableJavaScript: true,
                            //     // enableDomStorage: true,
                            //   );
                            // } else {
                            //   throw 'Could not open the map.';
                            // }
                          } else {
                            ShowToastDialog.showToast("please enter valid otp");
                          }
                        } else {
                          ShowToastDialog.showToast("please enter otp");
                        }
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      });
}

bool dateCheckwithCurrentTime(date) {
  String dateTimeString = "28 Jun, 2024 09:07 AM";
  DateTime dateTime = DateFormat("dd MMM, yyyy hh:mm a").parse(dateTimeString);
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(dateTime);

  bool isLessThanFiveHours = difference.inHours.abs() < 5;
  return isLessThanFiveHours;
}
