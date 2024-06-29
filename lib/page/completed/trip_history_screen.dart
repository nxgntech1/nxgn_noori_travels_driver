import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/payment_controller.dart';
import 'package:cabme_driver/model/tax_model.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/widget/StarRating.dart';
import 'package:cabme_driver/widget/appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes/Constants.dart';
import '../../themes/button_them.dart';
import '../../themes/responsive.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<PaymentController>(
        init: PaymentController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: CustomAppBar(title: "Trip Details"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                              children: [
                                (controller.data.value.vehicleImage != null && controller.data.value.vehicleImage != "null")
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          // imageUrl: controller.data.value.vehicleImageid.toString(),
                                          imageUrl: controller.data.value.vehicleImage.toString(),
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
                                          child: Text(controller.data.value.model.toString(),
                                              style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(controller.data.value.numberplate.toString(),
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
                                      child: buildStatusText(controller.data.value.statut.toString()),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
                                    controller.data.value.departName.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            //const Divider(),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.data.value.stops!.length,
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
                                              controller.data.value.stops![index].location.toString(),
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
                                    controller.data.value.destinationName.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Image.asset(
                            //       "assets/icons/ic_pic_drop_location.png",
                            //       height: 60,
                            //     ),
                            //     Expanded(
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 10),
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //                 controller.data.value.departName
                            //                     .toString(),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis),
                            //             const Divider(),
                            //             Text(
                            //                 controller.data.value.destinationName
                            //                     .toString(),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     Text(
                            //       "completed".tr,
                            //       style: TextStyle(color: ConstantColors.primary),
                            //     )
                            //   ],
                            // ),
                            // (controller.data.value.statut == "completed")
                            //     ?

                            //:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(left: 5.0),
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //             color: Colors.black12,
                                  //           ),
                                  //           borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.symmetric(vertical: 20),
                                  //         child: Column(
                                  //           children: [
                                  //             Image.asset(
                                  //               'assets/icons/passenger.png',
                                  //               height: 22,
                                  //               width: 22,
                                  //               color: ConstantColors.yellow,
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.only(top: 8.0),
                                  //               child: Text(" ${controller.data.value.numberPoeple.toString()}",
                                  //                   //DateFormat('\$ KK:mm a, dd MMM yyyy').format(date),
                                  //                   style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black54)),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                                              // Image.asset(
                                              //   'assets/icons/price.png',
                                              //   height: 22,
                                              //   width: 22,
                                              //   color: ConstantColors.yellow,
                                              // ),
                                              Text(
                                                Constant().amountShow(amount: controller.data.value.montant!.toString()),
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
                                                    "${double.parse(controller.data.value.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${controller.data.value.distanceUnit}",
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
                                                child: Text(controller.data.value.duree.toString(),
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
                            (controller.data.value.statut == "completed")
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                                      child: Text(controller.data.value.duree.toString(),
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
                                                          "${double.parse(controller.data.value.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${controller.data.value.distanceUnit}",
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
                                : const SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: controller.data.value.photoPath.toString(),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Constant.loader(),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/appIcon.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: controller.data.value.rideType! == 'driver' && controller.data.value.existingUserId.toString() == "null"
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('${controller.data.value.userInfo!.name}',
                                                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                Text('${controller.data.value.userInfo!.email}',
                                                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w400)),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${controller.data.value.prenom.toString()} ${controller.data.value.nom.toString()}",
                                                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                // StarRating(
                                                //     size: 18,
                                                //     rating: controller.data.value.moyenneDriver != "null" ? double.parse(controller.data.value.moyenneDriver.toString()) : 0.0,
                                                //     color: ConstantColors.yellow),
                                                if (controller.data.value.ride_required_on_date != null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5.0),
                                                    child: Text(controller.data.value.ride_required_on_date.toString(),
                                                        style: const TextStyle(color: Colors.black26, fontWeight: FontWeight.w600)),
                                                  ),
                                              ],
                                            ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          // if (controller.data.value.existingUserId.toString() != "null")
                                          //   InkWell(
                                          //       onTap: () {
                                          //         Get.to(ConversationScreen(), arguments: {
                                          //           'receiverId': int.parse(controller.data.value.idUserApp.toString()),
                                          //           'orderId': int.parse(controller.data.value.id.toString()),
                                          //           'receiverName': "${controller.data.value.prenom} ${controller.data.value.nom}",
                                          //           'receiverPhoto': controller.data.value.photoPath
                                          //         });
                                          //       },
                                          //       child: Image.asset(
                                          //         'assets/icons/chat_icon.png',
                                          //         height: 36,
                                          //         width: 36,
                                          //       )),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(left: 10),
                                          //   child: InkWell(
                                          //       onTap: () {
                                          //         if (controller.data.value.existingUserId.toString() == "null") {
                                          //           Constant.makePhoneCall(controller.data.value.userInfo!.phone.toString());
                                          //         } else {
                                          //           Constant.makePhoneCall(controller.data.value.phone.toString());
                                          //         }
                                          //       },
                                          //       child: Image.asset(
                                          //         'assets/icons/call_icon.png',
                                          //         height: 36,
                                          //         width: 36,
                                          //         color: Colors.white,
                                          //       )),
                                          // ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (controller.data.value.existingUserId.toString() == "null") {
                                                Constant.makePhoneCall(controller.data.value.userInfo!.phone.toString());
                                              } else {
                                                Constant.makePhoneCall(controller.data.value.phone.toString());
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                              shape: const CircleBorder(),
                                              backgroundColor: Colors.blue,
                                              padding: const EdgeInsets.all(6), // <-- Splash color
                                            ),
                                            child: const Icon(
                                              Icons.call,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 10),
                            // Row(
                            //   children: [
                            //     Visibility(
                            //       visible: controller.data.value.payment == "Cash" ? true : false,
                            //       child: Expanded(
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(bottom: 5),
                            //           child: ButtonThem.buildBorderButton(
                            //             context,
                            //             title: 'Cash'.tr,
                            //             btnHeight: 45,
                            //             btnWidthRatio: 0.8,
                            //             btnColor: Colors.white,
                            //             txtColor: Colors.black.withOpacity(0.60),
                            //             btnBorderColor: Colors.black.withOpacity(0.20),
                            //             onPress: () async {
                            //               // buildShowBottomSheet(context, data, controller);
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Visibility(
                            //       visible: controller.data.value.payment != "Cash" ? true : false,
                            //       child: Expanded(
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(bottom: 5),
                            //           child: ButtonThem.buildBorderButton(
                            //             context,
                            //             title: 'Paid'.tr,
                            //             btnHeight: 45,
                            //             btnWidthRatio: 0.8,
                            //             btnColor: Colors.white,
                            //             txtColor: Colors.black.withOpacity(0.60),
                            //             btnBorderColor: Colors.black.withOpacity(0.20),
                            //             onPress: () async {
                            //               // buildShowBottomSheet(context, data, controller);
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _openWhatsApp(ConstantNumbers.whatsappnumber), // Directly assign the onPressed callback
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: ConstantColors.primary), // Border color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Chat with Noori",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ConstantColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/images/whatsapp.png',
                                          height: 24, // Set your desired height
                                          width: 24, // Set your desired width
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Constant.makePhoneCall(ConstantNumbers.customerCareNumber),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: ConstantColors.primary), // Border color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8), // Rounded corners
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Talk to Noori",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ConstantColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/icons/call_icon.png',
                                          height: 24, // Set your desired height
                                          width: 24, // Set your desired width
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: Responsive.width(100, context) * 0.9,
                              child: OutlinedButton(
                                onPressed: () {}, // Directly assign the onPressed callback
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: ConstantColors.primary), // Border color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "View & Download Invoice",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ConstantColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      'assets/icons/invoice.png',
                                      height: 24, // Set your desired height
                                      width: 24, // Set your desired width
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 15.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       boxShadow: <BoxShadow>[
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.3),
                    //           blurRadius: 2,
                    //           offset: const Offset(2, 2),
                    //         ),
                    //       ],
                    //       borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(15.0),
                    //       child: Column(
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Expanded(
                    //                   child: Text(
                    //                 "Sub Total".tr,
                    //                 style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                    //               )),
                    //               Text(Constant().amountShow(amount: controller.data.value.montant!.toString()),
                    //                   style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                    //             ],
                    //           ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 3.0),
                    //   child: Divider(
                    //     color: Colors.black.withOpacity(0.40),
                    //   ),
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Text(
                    //       "Discount".tr,
                    //       style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                    //     )),
                    //     Text("(-${Constant().amountShow(amount: controller.discountAmount.value.toString())})",
                    //         style: const TextStyle(letterSpacing: 1.0, color: Colors.red, fontWeight: FontWeight.w800)),
                    //   ],
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 3.0),
                    //   child: Divider(
                    //     color: Colors.black.withOpacity(0.40),
                    //   ),
                    // ),

                    // ListView.builder(
                    //   itemCount: controller.data.value.taxModel!.length,
                    //   shrinkWrap: true,
                    //   padding: EdgeInsets.zero,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemBuilder: (context, index) {
                    //     TaxModel taxModel = controller.data.value.taxModel![index];
                    //     return Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                    //               style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                    //             ),
                    //             Text(Constant().amountShow(amount: controller.calculateTax(taxModel: taxModel).toString()),
                    //                 style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                    //           ],
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 3.0),
                    //           child: Divider(
                    //             color: Colors.black.withOpacity(0.40),
                    //           ),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Text(
                    //       "${Constant.taxName} ${Constant.taxType.toString() == "Percentage" ? "(${Constant.taxValue}%)" : "(${Constant.taxValue})"}",
                    //       style: TextStyle(
                    //           letterSpacing: 1.0,
                    //           color: ConstantColors.subTitleTextColor,
                    //           fontWeight: FontWeight.w600),
                    //     )),
                    //     Text(
                    //         Constant().amountShow(
                    //             amount: controller.taxAmount.value
                    //                 .toString()),
                    //         style: TextStyle(
                    //             letterSpacing: 1.0,
                    //             color: ConstantColors.titleTextColor,
                    //             fontWeight: FontWeight.w800)),
                    //   ],
                    // ),

                    // Visibility(
                    //   visible: controller.tipAmount.value == 0 ? false : true,
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //               child: Text(
                    //             "Driver Tip".tr,
                    //             style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                    //           )),
                    //           Text(Constant().amountShow(amount: controller.tipAmount.value.toString()),
                    //               style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w800)),
                    //         ],
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(vertical: 3.0),
                    //         child: Divider(
                    //           color: Colors.black.withOpacity(0.40),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Text(
                    //       "Total".tr,
                    //       style: TextStyle(letterSpacing: 1.0, color: ConstantColors.titleTextColor, fontWeight: FontWeight.w600),
                    //     )),
                    //     Text(Constant().amountShow(amount: controller.getTotalAmount().toString()),
                    //         style: TextStyle(letterSpacing: 1.0, color: ConstantColors.primary, fontWeight: FontWeight.w800)),
                    //   ],
                    // ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Expanded(
                    //             child: Text(
                    //               "Admin commission".tr,
                    //               style: TextStyle(letterSpacing: 1.0, color: ConstantColors.subTitleTextColor, fontWeight: FontWeight.w600),
                    //             ),
                    //           ),
                    //           Text(
                    //             "(-${Constant().amountShow(amount: controller.adminCommission.value.toString())})",
                    //             style: const TextStyle(letterSpacing: 1.0, color: Colors.red, fontWeight: FontWeight.w600),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         "Note : Admin commission will be debited from your wallet balance. \nAdmin commission will apply on trip Amount minus Discount(If applicable).".tr,
                    //         style: const TextStyle(color: Colors.red),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
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

  Widget buildStatusText(String statut) {
    if (statut == "vehicle assigned") {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4), // Add desired padding here
        decoration: BoxDecoration(
          color: ConstantColors.primary, // Background color
          borderRadius: BorderRadius.circular(4.0), // Optional: Rounded corners
        ),
        child: const Text(
          "vehicle assigned",
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
          "on ride",
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
          "completed",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
