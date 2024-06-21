import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/constant_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, this.title = "Home"});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                Get.back();
                // controller.getDrawerItems();
                //Scaffold.of(context).openDrawer();
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ConstantColors.primary,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: ConstantColors.primary.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded, color: Colors.white,
                    // Image.asset(
                    //   "assets/icons/ic_side_menu.png",
                    //   color: const Color.fromARGB(255, 255, 255, 255),
                  )),
            ),
          );
        },
      ),
      title: Text(
        title.tr,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: ConstantColors.primary,
    );
  }
}
