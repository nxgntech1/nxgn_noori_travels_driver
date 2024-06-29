// ignore_for_file: must_be_immutable

import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/phone_number_controller.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../themes/text_field_them.dart';

class MobileNumberScreen extends StatelessWidget {
  bool? isLogin;

  MobileNumberScreen({super.key, required this.isLogin});

  final controller = Get.put(PhoneNumberController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColors.background,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isLogin == true ? "Login With Phone".tr : "Signup".tr,
                          style: const TextStyle(letterSpacing: 0.60, fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.primary,
                              thickness: 3,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: ConstantColors.textFieldBoarderColor,
                            //     ),
                            //     borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.only(left: 10),
                            child:
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                // Text(
                                //   "Phone Number",
                                //   style: TextStyle(color: ConstantColors.titleTextColor, fontWeight: FontWeight.w600),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                //     TextFormField(
                                //         validator: (String? value) {
                                //           if (value!.length == 10) {
                                //             return null;
                                //           } else {
                                //             return 'Enter 10 digit mobile number'.tr;
                                //           }
                                //         },
                                //         maxLength: 10,
                                //         inputFormatters: <TextInputFormatter>[
                                //           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                //           FilteringTextInputFormatter.digitsOnly
                                //         ],
                                //         keyboardType: TextInputType.number,
                                //         textCapitalization: TextCapitalization.sentences,
                                //         controller: controller.passwordController,
                                //         textInputAction: TextInputAction.done,
                                //         style: TextStyle(color: ConstantColors.titleTextColor),
                                //         decoration: InputDecoration(
                                //             prefixIcon: const Padding(
                                //               padding: EdgeInsets.fromLTRB(15, 15, 12, 8),
                                //               child: Text("+91"),
                                //             ),
                                //             counterText: "",
                                //             contentPadding: const EdgeInsets.all(8),
                                //             fillColor: Colors.white,
                                //             filled: true,
                                //             focusedBorder: OutlineInputBorder(
                                //               borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //               borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                                //             ),
                                //             enabledBorder: OutlineInputBorder(
                                //               borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //               borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                                //             ),
                                //             errorBorder: OutlineInputBorder(
                                //               borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //               borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                                //             ),
                                //             border: OutlineInputBorder(
                                //               borderRadius: const BorderRadius.all(Radius.circular(10)),
                                //               borderSide: BorderSide(color: ConstantColors.textFieldBoarderColor, width: 0.7),
                                //             ),
                                //             hintText: "Phone Number",
                                //             hintStyle: TextStyle(color: ConstantColors.hintTextColor))),
                                //   ],
                                // ),

                                TextFieldThem.boxBuildTextFieldWithDigitsOnly(
                              hintText: 'Phone Number'.tr,
                              prefixIconOrImage: "+91",
                              controller: controller.passwordController,
                              textInputType: TextInputType.number,
                              maxLength: 10,
                              contentPadding: EdgeInsets.zero,
                              validators: (String? value) {
                                if (value!.length == 10) {
                                  return null;
                                } else {
                                  return 'Enter 10 digit mobile number'.tr;
                                }
                              },
                            ),
                            // IntlPhoneField(
                            //   countries: [],
                            //   onCountryChanged: (country){},
                            //   showCountryFlag: false,
                            //   initialCountryCode: "IN",
                            //   initialValue: "+91",
                            //   onChanged: (phone) {
                            //     controller.phoneNumber.value = phone.completeNumber;
                            //   },
                            //   invalidNumberMessage: "number invalid",
                            //   showDropdownIcon: false,
                            //   disableLengthCheck: true,
                            //   decoration: InputDecoration(
                            //     contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            //     hintText: 'Phone Number'.tr,
                            //     border: InputBorder.none,
                            //     isDense: true,
                            //   ),
                            // ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Continue'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () async {
                                FocusScope.of(context).unfocus();
                                if (controller.passwordController.value.text.length > 9) {
                                  controller.phoneNumber.value = "+91${controller.passwordController.value.text}";
                                  ShowToastDialog.showLoader("Code sending".tr);
                                  //controller.sendCode(controller.phoneNumber.value);
                                  await controller.sendCode(controller.phoneNumber.value);
                                } else {
                                  ShowToastDialog.showToast("Enter valid phone number");
                                }
                              },
                            )),
                        isLogin == true
                            ? Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: 'Login With Email'.tr,
                                  btnHeight: 50,
                                  btnBorderColor: ConstantColors.primary,
                                  btnColor: Colors.white,
                                  txtColor: ConstantColors.primary,
                                  onPress: () {
                                    FocusScope.of(context).unfocus();
                                    Get.back();
                                  },
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
