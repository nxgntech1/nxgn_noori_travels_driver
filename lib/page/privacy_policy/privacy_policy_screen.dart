import 'package:cabme_driver/controller/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../widget/appbar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(
        init: PrivacyPolicyController(),
        builder: (controller) {
          return Scaffold(
            appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child:CustomAppBar(title: "privacy_policy"),
          ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Obx(() => controller.privacyData.value.isNotEmpty
                  ? SingleChildScrollView(
                      child: Html(
                        data: controller.privacyData.value,
                      ),
                    )
                  : const Offstage()),
            ),
          );
        });
  }
}
