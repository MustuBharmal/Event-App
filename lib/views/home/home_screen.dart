import 'package:ems/views/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/events_feed_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static const String routeName = '/home-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.03),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customAppBar(context),
                Text(
                  "What Going on today",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                eventsFeed(),
                Obx(() => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : eventsIJoined())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
