import 'package:ems/model/group_member_model.dart';
import 'package:ems/views/registration/controller/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';
import '../home/bottom_bar_view.dart';

class RegisterEventView extends GetView<RegistrationController> {
  static const String routeName = '/register-event-view';

  RegisterEventView({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String eventImage = '';
    try {
      List media = controller.event.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
    return Scaffold(
      body: controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                      text: controller.event.eventName,
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
                                      text: controller.event.location,
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
                                  text: controller.event.eventDay,
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
                    controller.event.eventType == 'Individual'
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.3,
                                    child: elevatedButton(
                                      onPress: () {
                                        controller.joinedEvent(
                                            eventId: controller.event.id);
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
                        : Form(
                            key: formKey,
                            child: Column(
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
                                textFormFieldForController(
                                    hintText: 'Team Name',
                                    icon: ('assets/Header.png'),
                                    controller: controller.teamNameController,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        Get.snackbar(
                                            'Opps', "Team name is required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForController(
                                    hintText: 'Leader Name',
                                    icon: ('assets/Header.png'),
                                    obscure: false,
                                    controller: controller.leaderName,
                                    validator: (String input) {
                                      if (input.isEmpty) {
                                        Get.snackbar(
                                            'Opps', "Leader name Required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForController(
                                    controller: controller.leaderNum,
                                    inputType: TextInputType.number,
                                    hintText: 'Leader phone number',
                                    icon: ('assets/Header.png'),
                                    obscure: false,
                                    maxLength: 10,
                                    validator: (String input) {
                                      if (input.isEmpty) {
                                        Get.snackbar(
                                            'Opps', "Leader number required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForController(
                                    readOnly: true,
                                    inputType: TextInputType.emailAddress,
                                    controller: controller.leaderEmail,
                                    hintText: 'Leader email',
                                    icon: ('assets/Header.png'),
                                    obscure: false,
                                    validator: (String input) {
                                      if (input.isEmpty) {
                                        Get.snackbar(
                                            'Opps', "Leader email required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForController(
                                    controller: controller.leaderDept,
                                    hintText: 'Leader Dept',
                                    icon: ('assets/Header.png'),
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        Get.snackbar('Opps',
                                            "Leader department required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForController(
                                    inputType: TextInputType.number,
                                    hintText: 'Leader Sem',
                                    icon: ('assets/Header.png'),
                                    obscure: false,
                                    validator: (String input) {
                                      if (input.isEmpty) {
                                        Get.snackbar(
                                            'Opps', "Leader semester required",
                                            colorText: AppColors.white,
                                            backgroundColor: AppColors.blue);
                                        return '';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                textFormFieldForValue(
                                  inputType: TextInputType.number,
                                  icon: ('assets/Header.png'),
                                  hintText:
                                      'No. of members (excluding team leader)',
                                  validator: (input) {
                                    if (input.isEmpty) {
                                      Get.snackbar('Opps', "Count is required",
                                          colorText: AppColors.white,
                                          backgroundColor: AppColors.blue);
                                      return '';
                                    }
                                    if (controller.event.noOfParticipant! <
                                        (controller.noOfParticipant.value -
                                            1)) {
                                      Get.snackbar('Opps',
                                          "You have exceeds no of participants",
                                          colorText: AppColors.white,
                                          backgroundColor: AppColors.blue);
                                      return '';
                                    }
                                    return null;
                                  },
                                  onChanged: (String num) {
                                    if (controller.event.noOfParticipant! <=
                                        (int.parse(num))) {
                                      Get.snackbar('Opps',
                                          "You have exceeds no of participants",
                                          colorText: AppColors.white,
                                          backgroundColor: AppColors.blue);
                                      return '';
                                    } else {
                                      controller.noOfParticipant.value =
                                          int.parse(num);
                                    }
                                  },
                                ),
                                Obx(
                                  () => ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          controller.noOfParticipant.value,
                                      itemBuilder: (context, index) {
                                        controller.listOfEvent.clear();
                                        controller.listOfEvent.addAll(
                                            List.generate(
                                                controller
                                                    .noOfParticipant.value,
                                                (index) => GroupMemberModel()));
                                        return Column(
                                          children: [
                                            textFormFieldForValue(
                                                onChanged: (String value) {
                                                  controller.listOfEvent[index]
                                                      .membersName = value;
                                                },
                                                hintText:
                                                    'Member ${index + 1} Name',
                                                icon: ('assets/Header.png'),
                                                obscure: false,
                                                validator: (String input) {
                                                  if (input.isEmpty) {
                                                    Get.snackbar('Opps',
                                                        "Member name Required",
                                                        colorText:
                                                            AppColors.white,
                                                        backgroundColor:
                                                            AppColors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                }),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            textFormFieldForValue(
                                                onChanged: (String value) {
                                                  controller.listOfEvent[index]
                                                      .membersNum = value;
                                                },
                                                inputType: TextInputType.number,
                                                hintText:
                                                    'Member ${index + 1} phone number',
                                                icon: ('assets/Header.png'),
                                                obscure: false,
                                                maxLength: 10,
                                                validator: (String input) {
                                                  if (input.isEmpty) {
                                                    Get.snackbar('Opps',
                                                        "Member number required",
                                                        colorText:
                                                            AppColors.white,
                                                        backgroundColor:
                                                            AppColors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                }),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            textFormFieldForValue(
                                                onChanged: (String value) {
                                                  controller.listOfEvent[index]
                                                      .membersEmail = value;
                                                },
                                                inputType:
                                                    TextInputType.emailAddress,
                                                hintText:
                                                    'Member ${index + 1} email',
                                                icon: ('assets/Header.png'),
                                                obscure: false,
                                                validator: (String input) {
                                                  if (input.isEmpty) {
                                                    Get.snackbar('Opps',
                                                        "Member email required",
                                                        colorText:
                                                            AppColors.white,
                                                        backgroundColor:
                                                            AppColors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                }),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            textFormFieldForValue(
                                                onChanged: (String value) {
                                                  controller.listOfEvent[index]
                                                          .membersDept =
                                                      value.toLowerCase();
                                                },
                                                hintText:
                                                    'Member ${index + 1} Dept',
                                                icon: ('assets/Header.png'),
                                                validator: (input) {
                                                  if (input.isEmpty) {
                                                    Get.snackbar('Opps',
                                                        "Member department required",
                                                        colorText:
                                                            AppColors.white,
                                                        backgroundColor:
                                                            AppColors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                }),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            textFormFieldForValue(
                                                onChanged: (String value) {
                                                  controller.listOfEvent[index]
                                                      .membersSem = value;
                                                },
                                                maxLength: 1,
                                                inputType: TextInputType.number,
                                                hintText:
                                                    'Member ${index + 1} Sem',
                                                icon: ('assets/Header.png'),
                                                obscure: false,
                                                validator: (String input) {
                                                  if (input.isEmpty) {
                                                    Get.snackbar('Opps',
                                                        "Member semester required",
                                                        colorText:
                                                            AppColors.white,
                                                        backgroundColor:
                                                            AppColors.blue);
                                                    return '';
                                                  }
                                                  return null;
                                                }),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                                Obx(
                                  () => controller.isLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : elevatedButton(
                                          onPress: () async {
                                            if (!formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            controller.groupEventSubmit(
                                                eventId: controller.event.id);
                                          },
                                          text: 'Submit',
                                        ),
                                )
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
