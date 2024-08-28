// ignore_for_file: library_private_types_in_public_api
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/appbar.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'Contact Us',
      //   onPressed: () {
      //     String url = 'tel:${Constant.contactUsPhone}';
      //     launchUrl(Uri.parse(url));
      //   },
      //   backgroundColor: ConstantColors.primary,
      //   child: const Icon(
      //     CupertinoIcons.phone_solid,
      //     color: Colors.white,
      //   ),
      // ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: "Payment"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            // Use Expanded to take up remaining space in the Column
            child: Material(
              // elevation: 2,
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  color: const Color.fromARGB(255, 245, 245, 247),
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Image.asset(
                      'assets/images/payment.jpg',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
