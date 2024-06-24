import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/button_them.dart';
import '../../../themes/constant_colors.dart';

class BookingConfirmation extends StatelessWidget {
  const BookingConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    final String bookingType = arguments['booking_type'] as String? ?? 'No Data';
    final String finalAmount = arguments['finalAmount'] as String? ?? 'No Data';
    final String destinationName = arguments['destination_name'] as String? ?? 'No Data';
    final String departName = arguments['depart_name'] as String? ?? 'No Data';
    final String carBrandname = arguments['car_brandname'] as String? ?? 'No Data';
    final String carModelname = arguments['car_modelname'] as String? ?? 'No Data';
    final String bookforOthersName = arguments['bookfor_others_name'] as String? ?? '';
    final String rideDate = arguments['ride_date'] as String? ?? 'No Data';
    final String rideTime = arguments['ride_time'] as String? ?? 'No Data';

    // final String bookingMessage =
    // bookforOthersName.isEmpty ? "Your booking is completed. \n We will contact you in some time." : "Your booking is completed for ";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // iconTheme: const IconThemeData(
        //   color: Colors.white, //change your color here
        // ),
        title: const Text(
          "Payment Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/like.png', height: 80),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    "Payment Made!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    "Your booking completed $bookforOthersName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
                  ),
                ),
                // RichText(
                //   textAlign: TextAlign.center,
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: bookingMessage,
                //         style: const TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
                //       ),
                //       if (bookforOthersName.isNotEmpty)
                //         TextSpan(
                //           text: bookforOthersName,
                //           style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                //         ),
                //       const TextSpan(
                //         text: '\nWe will contact you in some time.',
                //         style: TextStyle(color: Color.fromARGB(255, 97, 97, 97)),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Package Type: ")),
                    Expanded(
                        child: Text(
                      bookingType,
                      textAlign: TextAlign.right,
                    )),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Scheduled date & time: ")),
                    Expanded(
                      child: Text(
                        rideDate,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Car Details: ")),
                    Expanded(
                      child: Text(
                        "$carBrandname $carModelname",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Pick-up address: ")),
                    Expanded(
                      child: Text(
                        departName,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Drop Address: ")),
                    Expanded(
                      child: Text(
                        destinationName,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                const Divider(
                  color: Color.fromARGB(0, 255, 255, 255),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Total Fare :")),
                    Expanded(
                      child: Text(
                        finalAmount,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: ConstantColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ButtonThem.buildButton(
                          context,
                          btnHeight: 40,
                          title: "Home",
                          btnColor: ConstantColors.primary,
                          txtColor: Colors.white,
                          onPress: () {
                            // if (mounted) {
                            Get.back();
                            // }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
