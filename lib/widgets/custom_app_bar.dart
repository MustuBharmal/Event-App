import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import '../views/notification_screen/notification_screen.dart';
import 'my_widgets.dart';

Widget customAppBar(context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      children: [
        SizedBox(
          width: Get.width * 0.30,
          height: Get.height * 0.025,
          child: myText(
            text: 'Atmiya University',
            style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: Get.width * 0.06,
          height: Get.height * 0.02,
          child: InkWell(
            onTap: () {
              Get.to(() => const UserNotificationScreen());
            },
            child: Image.asset('assets/Frame.png'),
          ),
        ),
      ],
    ),
  );
}
