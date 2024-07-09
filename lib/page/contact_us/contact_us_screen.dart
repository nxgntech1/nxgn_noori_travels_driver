// ignore_for_file: library_private_types_in_public_api
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/appbar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
        child: CustomAppBar(title: "contact_us"),
      ),
      body: Column(children: <Widget>[
        Material(
            // elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Please choose the appropriate support method'.tr,
                    style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.black, //                   <--- border color
                    //   width: 1.0,
                    // ),
                    // borderRadius: const BorderRadius.all(
                    //   Radius.circular(10.0),
                    // ),
                    // boxShadow: [
                    //   BoxShadow(color: const Color(0xFFDFDFDF).withOpacity(0.8), offset: const Offset(0, 0), blurRadius: 5, spreadRadius: 3),
                    // ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.06),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      String url = 'tel:${Constant.contactUsPhone}';
                      launchUrl(Uri.parse(url));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                'Call'.tr,
                                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                              child: Text(
                                Constant.contactUsPhone!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            //   child: Text(
                            //     "Support Time : ${Constant.office_timmings}",
                            //     style: const TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.black, //                   <--- border color
                    //   width: 1.0,
                    // ),
                    // borderRadius: const BorderRadius.all(
                    //   Radius.circular(10.0),
                    // ),
                    // boxShadow: [
                    //   BoxShadow(color: const Color(0xFFDFDFDF).withOpacity(0.8), offset: const Offset(0, 0), blurRadius: 5, spreadRadius: 3),
                    // ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.06),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // String email = Constant.contactUsEmail!; // Replace with your actual email
                      // String url = 'mailto:$email';
                      // launchUrl(Uri.parse(url));
                      String url = 'mailto: ${Constant.contactUsEmail}';
                      launchUrl(Uri.parse(url));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                'E-mail'.tr,
                                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                              child: Text(
                                Constant.contactUsEmail!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            //   child: Text(
                            //     "Support 24/7",
                            //     style: TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.black, //                   <--- border color
                    //   width: 1.0,
                    // ),
                    // borderRadius: const BorderRadius.all(
                    //   Radius.circular(10.0),
                    // ),
                    // boxShadow: [
                    //   BoxShadow(color: const Color(0xFFDFDFDF).withOpacity(0.8), offset: const Offset(0, 0), blurRadius: 5, spreadRadius: 3),
                    // ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.06),
                        spreadRadius: 1,
                        blurRadius: 20,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      _openWhatsApp(Constant.contactUsPhone!);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(
                                'WhatsApp'.tr,
                                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                              child: Text(
                                Constant.contactUsPhone!,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            //   child: Text(
                            //     "Support Time : ${Constant.office_timmings}",
                            //     style: const TextStyle(color: Colors.black54),
                            //   ),
                            // ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                // ListTile(
                //   title: Text(
                //     'Email Us'.tr,
                //     style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(Constant.contactUsEmail ?? ''),
                //   trailing: InkWell(
                //     onTap: () {
                //       String url = 'mailto: ${Constant.contactUsEmail}';
                //       launchUrl(Uri.parse(url));
                //     },
                //     child: const Icon(
                //       CupertinoIcons.chevron_forward,
                //       color: Colors.black54,
                //     ),
                //   ),
                // )
              ]),
            )),
      ]),
    );
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
