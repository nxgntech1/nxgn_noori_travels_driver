import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/payment_controller.dart';
import 'package:cabme_driver/controller/trip_history_screen_controller.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/widget/appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cabme_driver/model/trip_ride_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../themes/button_them.dart';
import '../../themes/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});
  final String phoneNumber = "+918686908170";

  @override
  Widget build(BuildContext context) {
    return GetX<TripHistoryScreenController>(
      init: TripHistoryScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: ConstantColors.primary,
              title: const Text("Trip Details", style: TextStyle(color: Colors.white)),
              leading: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          body: controller.isLoading.value
              ? Constant.loader()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    child:
                        //Obx(() =>
                        Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              controller.singleRideDetails[0].vehicleImageid != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: controller.singleRideDetails[0].vehicleImageid.toString(),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Constant.loader(),
                                        errorWidget: (context, url, error) => Image.asset(
                                          "assets/images/car.png",
                                        ),
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/images/car.png",
                                      height: 60,
                                      width: 60,
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text("${controller.singleRideDetails[0].model}",
                                            style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            "${controller.singleRideDetails[0].bookigDate != null ? '${DateFormat('dd MMM yyyy').format(DateTime.parse(controller.singleRideDetails[0].bookigDate.toString()))},' : ""}  ${controller.singleRideDetails[0].bookingTime != null ? controller.singleRideDetails[0].bookingTime.toString() : ""} ",
                                            // "${controller.singleRideDetails[0].creer.toString()} | ${controller.formattedTime.value} ",
                                            style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w400)),
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
                                    child: buildStatusText(controller.singleRideDetails[0].statut.toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5, right: 10),
                                    child: Text(
                                      controller.singleRideDetails[0].montant.toString(),
                                      //Constant().amountShow(amount: controller.getTotalAmount().toString()),
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                  controller.singleRideDetails[0].bookingtype.toString(),
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
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                            child: Column(
                              children: [
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
                                          height: 38,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.singleRideDetails[0].departName ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
                                        controller.singleRideDetails[0].destinationName ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                (controller.singleRideDetails[0].statut == "completed")
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
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
                                                          "Trip Duration",
                                                          style: TextStyle(fontSize: 14, color: ConstantColors.primary, fontWeight: FontWeight.bold),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 8.0),
                                                          child: Text(controller.formattedTime.toString(),
                                                              //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 13)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
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
                                                          "Trip Distance",
                                                          style: TextStyle(fontSize: 14, color: ConstantColors.primary, fontWeight: FontWeight.w800),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 8.0),
                                                          child: Text(
                                                              "${double.parse(controller.singleRideDetails[0].distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${controller.singleRideDetails[0].distanceUnit}",
                                                              //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
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
                                                            'assets/images/location.png',
                                                            height: 32,
                                                            width: 32,
                                                            color: ConstantColors.yellow,
                                                          ),
                                                          Text(
                                                            controller.singleRideDetails[0].bookingTime ?? "",
                                                            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
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
                                                                "${double.parse(controller.singleRideDetails[0].distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${controller.singleRideDetails[0].distanceUnit}",
                                                                //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
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
                                                  padding: const EdgeInsets.all(12.0),
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
                                                            child: Text(controller.singleRideDetails[0].duree!.replaceAll('hours', 'hrs').toString(),
                                                                //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                                                style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, fontSize: 11)),
                                                          ),
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
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                                            child: Divider(
                                              color: Colors.black.withOpacity(0.20),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Car Price".tr,
                                                  style: TextStyle(
                                                      letterSpacing: 1.0, fontSize: 15, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                              Text(
                                                controller.singleRideDetails[0].carPrice ?? "0.00",
                                                style: TextStyle(
                                                    letterSpacing: 1.0, fontSize: 15, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          controller.singleRideDetails[0].discount! != "0.00"
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          "Discount".tr,
                                                          style: TextStyle(
                                                              letterSpacing: 1.0,
                                                              fontSize: 15,
                                                              color: ConstantColors.subTitleTextColor,
                                                              fontWeight: FontWeight.w500),
                                                        )),
                                                        Text(controller.singleRideDetails[0].discount ?? "",
                                                            style: const TextStyle(
                                                                letterSpacing: 1.0,
                                                                fontSize: 15,
                                                                color: Color.fromARGB(255, 3, 66, 5),
                                                                fontWeight: FontWeight.w500)),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                                                      child: Divider(
                                                        color: Colors.black.withOpacity(0.20),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          "Sub Total".tr,
                                                          style: TextStyle(
                                                              letterSpacing: 1.0,
                                                              fontSize: 15,
                                                              color: ConstantColors.subTitleTextColor,
                                                              fontWeight: FontWeight.w500),
                                                        )),
                                                        Text(controller.singleRideDetails[0].subTotal.toString(),
                                                            style: TextStyle(
                                                                letterSpacing: 1.0,
                                                                fontSize: 15,
                                                                color: ConstantColors.subTitleTextColor,
                                                                fontWeight: FontWeight.w500)),
                                                        const SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(height: 0),
                                          ListView.builder(
                                            itemCount: controller.singleRideDetails[0].tax!.length,
                                            shrinkWrap: true,
                                            padding: controller.singleRideDetails[0].statutPaiement == "yes" ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              Tax taxModel = controller.singleRideDetails[0].tax![index];
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${taxModel.taxlabel.toString()} (${taxModel.taxType == "Fixed" ? Constant().amountShow(amount: taxModel.tax) : "${taxModel.tax}%"})',
                                                        style: TextStyle(
                                                            letterSpacing: 1.0,
                                                            fontSize: 15,
                                                            color: ConstantColors.subTitleTextColor,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                      Text(taxModel.rideTaxAmount.toString(),
                                                          style: TextStyle(
                                                              letterSpacing: 1.0,
                                                              fontSize: 15,
                                                              color: ConstantColors.subTitleTextColor,
                                                              fontWeight: FontWeight.w500)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              );
                                            },
                                          ),

                                          /* driver Tip */
                                          Visibility(
                                            visible: controller.singleRideDetails[0].tipAmount!.isNotEmpty ? false : true,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                      "Driver Tip".tr,
                                                      style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          fontSize: 15,
                                                          color: ConstantColors.subTitleTextColor,
                                                          fontWeight: FontWeight.w500),
                                                    )),
                                                    Text(Constant().amountShow(amount: controller.singleRideDetails[0].tipAmount),
                                                        style: TextStyle(
                                                            letterSpacing: 1.0,
                                                            fontSize: 15,
                                                            color: ConstantColors.subTitleTextColor,
                                                            fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                "Total Amount".tr,
                                                style: TextStyle(
                                                  letterSpacing: 1.0,
                                                  fontSize: 16,
                                                  color: ConstantColors.titleTextColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )),
                                              Text(
                                                controller.singleRideDetails[0].montant ?? "",
                                                style: TextStyle(
                                                  letterSpacing: 1.0,
                                                  fontSize: 16,
                                                  color: ConstantColors.primary,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: Divider(
                                              color: Colors.black.withOpacity(0.20),
                                            ),
                                          ),
                                          for (int i = 0; i < controller.singleRideDetails[0].addon!.length; i++)
                                            Container(
                                              // height: 25,
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(bottom: 15),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: ConstantColors.primary, width: 1),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Add-ons Package",
                                                        style: TextStyle(
                                                            letterSpacing: 1.0,
                                                            fontSize: 15,
                                                            color: ConstantColors.subTitleTextColor,
                                                            fontWeight: FontWeight.bold),
                                                      )),
                                                      Text(
                                                        "${controller.singleRideDetails[0].addon?[i].addOnLabel}",
                                                        style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          fontSize: 15,
                                                          color: ConstantColors.subTitleTextColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text("Payment Mode",
                                                              style: TextStyle(
                                                                letterSpacing: 1.0,
                                                                fontSize: 15,
                                                                color: ConstantColors.subTitleTextColor,
                                                              ))),
                                                      Text(
                                                        "${controller.singleRideDetails[0].addon?[i].paymentStatus}",
                                                        style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          fontSize: 15,
                                                          color: ConstantColors.subTitleTextColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Package Fare",
                                                        style: TextStyle(
                                                            letterSpacing: 1.0,
                                                            fontSize: 15,
                                                            color: ConstantColors.subTitleTextColor,
                                                            fontWeight: FontWeight.w500),
                                                      )),
                                                      Text(
                                                        "${controller.singleRideDetails[0].addon?[i].packagePrice}",
                                                        style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          fontSize: 15,
                                                          color: ConstantColors.subTitleTextColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  for (int j = 0; j < controller.singleRideDetails[0].addon![i].taxes!.length; j++)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                            "${controller.singleRideDetails[0].addon![i].taxes![j].taxlabel}",
                                                            style: TextStyle(
                                                                letterSpacing: 1.0,
                                                                fontSize: 15,
                                                                color: ConstantColors.subTitleTextColor,
                                                                fontWeight: FontWeight.w500),
                                                          )),
                                                          Text(
                                                            "${controller.singleRideDetails[0].addon![i].taxes![j].rideTaxAmount}",
                                                            style: TextStyle(
                                                              letterSpacing: 1.0,
                                                              fontSize: 15,
                                                              color: ConstantColors.subTitleTextColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                  // const SizedBox(height: 10),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                                    child: Divider(
                                                      color: Colors.black.withOpacity(0.20),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        "Total Amount",
                                                        style: TextStyle(
                                                            letterSpacing: 1.0, fontSize: 15, color: ConstantColors.primary, fontWeight: FontWeight.bold),
                                                      )),
                                                      Text(
                                                        "${controller.singleRideDetails[0].addon?[i].addonTotalAmount}",
                                                        style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          fontSize: 15,
                                                          color: ConstantColors.primary,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                (controller.singleRideDetails[0].numberplate ?? "").isNotEmpty
                                    ? Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Driver Details",
                                                style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: Row(
                                              children: [
                                                (controller.singleRideDetails[0].driverphoto != null && controller.singleRideDetails[0].driverphoto != "")
                                                    ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(50),
                                                        child: CachedNetworkImage(
                                                          imageUrl: controller.singleRideDetails[0].driverphoto
                                                              .toString(), //controller.singleRideDetails.driverphoto.toString(),
                                                          height: 60,
                                                          width: 60,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context, url) => Constant.loader(),
                                                          errorWidget: (context, url, error) => Image.asset(
                                                            "assets/images/user.png",
                                                          ),
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        "assets/images/user.png",
                                                        height: 60,
                                                        width: 60,
                                                      ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            controller.singleRideDetails[0].numberplate ??
                                                                "", //controller.singleRideDetails.numberplate.toString(),
                                                            style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                                                        const SizedBox(height: 6),
                                                        Text(
                                                            "${controller.singleRideDetails[0].drivername ?? "" /*controller.data.value.prenomConducteur.toString() */} ", //controller.data.value.nomConducteur.toString()
                                                            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Constant.makePhoneCall(controller.singleRideDetails[0].driverPhone ?? "");
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
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(
                                        height: 0,
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: true,
                                      child: Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: ButtonThem.buildBorderButton(
                                            context,
                                            title: '${controller.singleRideDetails[0].payment}',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget buildStatusText(String statut) {
    if (statut == "new") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: ConstantColors.primary, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "New",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    } else if (statut == "vehicle assigned") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: ConstantColors.primary, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "Vehicle Assigned",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    } else if (statut == "start trip") {
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
    } else if (statut == "arrived") {
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
    } else if (statut == "on ride") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: Colors.red[400],
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

  void _openWhatsApp(String phone) async {
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$phone?text=Hi, thanks for your message! Our support agents will check your message and make sure it is forwarded to the best-fit person. We will respond to you within 24 hours ");

    if (await canLaunch(whatsappUrl.toString())) {
      await launch(whatsappUrl.toString());
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
