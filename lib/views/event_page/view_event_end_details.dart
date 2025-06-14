import 'package:ems/views/event_page/controller/event_page_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class ViewEndEventDetails extends GetView<EventPageController> {
  static const String routeName = '/view-end-event-details';

  const ViewEndEventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 27,
                          height: 27,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/circle.png'),
                            ),
                          ),
                          child: Image.asset('assets/bi_x-lg.png'),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: myText(
                            text: 'Details',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Text(''),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 1,
                          color: const Color(0xff393939).withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(controller.eventImage.value),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              myText(
                                text: controller.event?.eventName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    // width: 11.67,
                                    height: 15,
                                    child: Image.asset(
                                      'assets/location.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  myText(
                                    text: controller.event?.location!
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: Get.width * 0.45,
                                child: myText(
                                    text: '${controller.event?.description}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blue,
                                    ),
                                    maxLines: 3),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              myText(
                                text:
                                    'Event Date:- ${controller.event?.eventDay}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text:
                                    'Total seats available:-  ${controller.event!.maxEntries! + controller.event!.joined.length}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text:
                                    'No. of Entries:-  ${controller.event?.joined.length}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              myText(
                                text: 'Venue:-  ${controller.event?.location}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : elevatedButton(
                      text: "Download excel",
                      onPress: () {
                        controller.event?.eventType == 'Individual'
                            ? controller.individualExcelSheet()
                            : controller.groupEventExcelSheet();
                        controller.writeCounter(controller.excel);
                      }),
            )
          ],
        ),
      ),
    );
  }
}
