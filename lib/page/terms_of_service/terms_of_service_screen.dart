import 'package:cabme_driver/controller/terms_of_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../widget/appbar.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsOfServiceController>(
        init: TermsOfServiceController(),
        builder: (controller) {
          return Scaffold(
            appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child:CustomAppBar(title: "term_service"),
          ),
            body: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Obx(() => controller.data.value.isNotEmpty
                  ? SingleChildScrollView(
                      child: Html(
                        data: controller.data.value,
                      ),
                    )
                  : const Offstage()),
            ),
          );
        });
  }
}
