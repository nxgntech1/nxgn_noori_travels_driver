import 'dart:io';

import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/dash_board_controller.dart';
import 'package:cabme_driver/controller/document_status_contoller.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/custom_alert_dialog.dart';
import 'package:cabme_driver/themes/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/appbar.dart';

class DocumentStatusScreen extends StatelessWidget {
  DocumentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<DocumentStatusController>(
      init: DocumentStatusController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(title: "Documents"),
          ),
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      //const Text("     Document details",style: TextStyle(fontSize:16,color: Color(0xff9090AD)),),
                      ListView.builder(
                        itemCount: controller.documentList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "  ${controller.documentList[index].documentName.toString()}",
                                            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        controller.documentList[index].documentStatus == "Disapprove"
                                            ? InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    barrierColor: Colors.black26,
                                                    context: context,
                                                    builder: (context) {
                                                      return CustomAlertDialog(
                                                        title:
                                                            "Reason : ${controller.documentList[index].comment!.isEmpty ? "Under Verification".tr : controller.documentList[index].comment.toString()}",
                                                        negativeButtonText: 'Ok'.tr,
                                                        positiveButtonText: 'Ok'.tr,
                                                        onPressPositive: () {
                                                          Get.back();
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(Icons.remove_red_eye))
                                            : Container(),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                                              border: Border.all(
                                                  color: controller.documentList[index].documentStatus == "Disapprove" ||
                                                          controller.documentList[index].documentStatus == "Pending"
                                                      ? Colors.red
                                                      : Colors.green)),
                                          child: Text(
                                            controller.documentList[index].documentStatus.toString(),
                                            style: TextStyle(
                                                color: controller.documentList[index].documentStatus == "Disapprove" ||
                                                        controller.documentList[index].documentStatus == "Pending"
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    controller.documentList[index].documentPath!.isEmpty
                                        ? Container()
                                        : ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Image.network(
                                              controller.documentList[index].documentPath!,
                                              height: Responsive.height(25, context),
                                              width: Responsive.width(90, context),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible: controller.documentList[index].documentStatus != "Approved",
                                      child: GestureDetector(
                                        onTap: () {
                                          buildBottomSheet(context, controller, index, controller.documentList[index].id.toString());
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: const Color(0xff22215B).withOpacity(0.1))),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Upload ${controller.documentList[index].documentName}", style: const TextStyle(color: Color(0xff9090AD))),
                                              Icon(Icons.file_upload_outlined, color: ConstantColors.primary),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: Visibility(
          //   visible: true,
          // child: ButtonThem.buildButton(
          //   Get.context!,
          //   title: "Home".tr,
          //   btnHeight: 35,
          //   btnWidthRatio: 0.8,
          //   btnColor: ConstantColors.primary,
          //   txtColor: Colors.white,
          //   onPress: () {
          //     Get.find<DashBoardController>().selectedDrawerIndex.value = 0;
          //   },
          // ),
          // )
        );
      },
    );
  }

  buildBottomSheet(BuildContext context, DocumentStatusController controller, int index, String documentId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: Responsive.height(22, context),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'please_select'.tr,
                      style: TextStyle(
                        color: const Color(0XFF333333).withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller, source: ImageSource.camera, index: index, documentId: documentId),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text('camera'.tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => pickFile(controller, source: ImageSource.gallery, index: index, documentId: documentId),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text('gallery'.tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile(DocumentStatusController controller, {required ImageSource source, required int index, required String documentId}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      final croppedFile = await _cropImage(File(image.path));
      if (croppedFile == null) {
        return;
      }
      controller.updateDocument(documentId, croppedFile.path).then((value) {
        controller.isLoading.value = true;
        controller.getCarServiceBooks();
      });
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to Pick".tr}: \n $e");
    }
  }

  buildAlertSendInformation(
    BuildContext context,
  ) {
    return Get.defaultDialog(
      radius: 6,
      title: "",
      titleStyle: const TextStyle(fontSize: 0.0),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/green_checked.png",
                height: 100,
                width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "${"Your information send well. We will treat them and inform you after the treatment.".tr} ${"Your account will be active after validation of your information.".tr}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonThem.buildButton(context,
                title: "Close".tr, btnHeight: 40, btnWidthRatio: 0.6, btnColor: ConstantColors.primary, txtColor: Colors.white, onPress: () => Get.back()),
          ],
        ),
      ),
    );
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 50,
        maxWidth: 200,
        maxHeight: 200,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: ConstantColors.primary,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black, // Set the background color
            activeControlsWidgetColor: ConstantColors.primary, // Active controls color
            dimmedLayerColor: Colors.black.withOpacity(0.7), // Dimmed layer color
            cropFrameColor: ConstantColors.primary, // Crop frame color
            cropGridColor: Colors.white, // Crop grid color
            initAspectRatio: CropAspectRatioPreset.original,

            lockAspectRatio: true,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
    } catch (e) {
      print('Error cropping image: $e');
      return null; // Handle or log the error accordingly
    }
  }
}
