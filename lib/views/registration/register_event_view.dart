import 'package:ems/model/event_model.dart';
import 'package:ems/services/payment_service/payment_service.dart';
import 'package:ems/views/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';
import '../home/bottom_bar_view.dart';

class RegisterEventView extends GetView<RegistrationController> {
  static const String routeName = '/register-event-view';

  const RegisterEventView({super.key});

  @override
  Widget build(BuildContext context) {
    EventModel event = Get.arguments;
    String eventImage = '';
    try {
      List media = event.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    child: InkWell(
                      onTap: () => Get.back(),
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
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: myText(
                        text: 'Registration',
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
                height: 150,
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
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(eventImage),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              myText(
                                text: event.eventName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 11.67,
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
                                text: event.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          myText(
                            text: event.eventDay,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              event.eventType == 'Individual'
                  ? Column(
                      children: [
                        Center(
                          child: myText(
                            text: 'Do you want to join the event?',
                            style: TextStyle(
                              fontSize: Get.width * 0.06,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: Get.width * 0.3,
                              child: elevatedButton(
                                onPress: () {
                                  joinedEvent(context, eventId: event.id);
                                },
                                text: 'YES',
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.3,
                              child: elevatedButton(
                                onPress: () {
                                  Get.offAll(const BottomBarView());
                                },
                                text: 'NO',
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Center(
                          child: myText(
                            text: 'Do you want to join group event?',
                            style: TextStyle(
                              fontSize: Get.width * 0.06,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        myTextField(
                            hintText: 'Team leader',
                            icon: ('assets/Header.png'),
                            obscure: false),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'No. of members (excluding team leader)',
                          ),
                          onChanged: (String num) {
                            controller.noOfParticipant.value = int.parse(num);
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Obx(
                          () => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.noOfParticipant.value,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [

                                    myTextField(
                                        hintText: 'Member Name ${index + 1}',
                                        icon: ('assets/Header.png'),
                                        obscure: false),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    myTextField(
                                        hintText: 'Member email ${index + 1}',
                                        icon: ('assets/Header.png'),
                                        obscure: false),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    myTextField(
                                        hintText: 'Member Dept ${index + 1}',
                                        icon: ('assets/Header.png'),
                                        obscure: false),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    myTextField(
                                        hintText: 'Member Sem ${index + 1}',
                                        icon: ('assets/Header.png'),
                                        obscure: false),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),

                                  ],
                                );
                              }),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     SizedBox(
                        //       width: Get.width * 0.3,
                        //       child: elevatedButton(
                        //         onPress: () {
                        //           joinedEvent(context, eventId: event.id);
                        //         },
                        //         text: 'YES',
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: Get.width * 0.3,
                        //       child: elevatedButton(
                        //         onPress: () {
                        //           Get.offAll(const BottomBarView());
                        //         },
                        //         text: 'NO',
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
