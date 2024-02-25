import 'package:dotted_border/dotted_border.dart';
import 'package:ems/views/create_event/controller/create_event_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CreateEventView extends GetView<CreateEventController> {
  CreateEventView({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                iconWithTitle(text: 'Create Event', func: () {}),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 33,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 0.6))),
                      child: Obx(
                        () => DropdownButton(
                          isExpanded: true,
                          underline: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     width: 0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              ),

                          // borderRadius: BorderRadius.circular(10),
                          icon: Image.asset('assets/arrowDown.png'),
                          elevation: 16,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          value: controller.participantType.value,
                          onChanged: (String? newValue) {
                            controller.participantType.value = newValue!;
                          },
                          items: controller.participantTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 0),
                      width: 90,
                      height: 33,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 0.6))),
                      child: Obx(
                        () => DropdownButton(
                          isExpanded: true,
                          underline: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     width: 0,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              ),

                          // borderRadius: BorderRadius.circular(10),
                          icon: Image.asset('assets/arrowDown.png'),
                          elevation: 16,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                          value: controller.eventType.value,
                          onChanged: (String? newValue) {
                            controller.eventType.value = newValue!;
                          },
                          items: controller.eventTypeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Obx(
                  () => Visibility(
                    visible: controller.eventType.value == 'Group',
                    child: myTextField(
                        obscure: false,
                        icon: 'assets/4DotIcon.png',
                        hintText: 'No of Participants',
                        controller: controller.noOfParticipantController,
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar('Opps', "No of Participants Required",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                            return '';
                          }
                          return null;
                        }),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  height: Get.width * 0.6,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: DottedBorder(
                    color: AppColors.border,
                    strokeWidth: 1.5,
                    dashPattern: const [6, 6],
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          SizedBox(
                            width: 76,
                            height: 59,
                            child: Image.asset('assets/uploadIcon.png'),
                          ),
                          myText(
                            text: 'Click and upload image/video',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          elevatedButton(
                              onPress: () async {
                                controller.imageDialog(context);
                              },
                              text: 'Upload')
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.media.isEmpty
                      ? Container()
                      : const SizedBox(
                          height: 20,
                        ),
                ),
                Obx(
                  () => controller.media.isEmpty
                      ? Container()
                      : SizedBox(
                          width: Get.width,
                          height: Get.width * 0.3,
                          child: ListView.builder(
                              itemBuilder: (ctx, i) {
                                return Container(
                                  width: Get.width * 0.3,
                                  height: Get.width * 0.3,
                                  margin: const EdgeInsets.only(
                                      right: 15, bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(
                                            controller.media[i].image!),
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: CircleAvatar(
                                          child: IconButton(
                                            onPressed: () {
                                              // obx
                                              controller.media.removeAt(i);
                                              // isImage.removeAt(i);
                                              // thumbnail.removeAt(i);
                                            },
                                            icon: const Icon(Icons.close),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              itemCount: controller.media.length,
                              scrollDirection: Axis.horizontal),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                myTextField(
                    obscure: false,
                    icon: 'assets/4DotIcon.png',
                    hintText: 'Event Name',
                    controller: controller.eventNameController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Event name is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar(
                            'Opps', "Event name is should be 3+ characters.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                myTextField(
                    obscure: false,
                    icon: 'assets/location.png',
                    hintText: 'Location',
                    controller: controller.locationController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Location is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar('Opps', "Location is Invalid.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      isReadOnly: true,
                      path: 'assets/Frame1.png',
                      text: 'Reg start date',
                      controller: controller.rgStDateController,
                      validator: (input) {
                        if (controller.date == null) {
                          Get.snackbar('Opps', "Date is required.",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        controller.selectDate(
                            context, controller.rgStDateController);
                      },
                    ),
                    iconTitleContainer(
                      isReadOnly: true,
                      path: 'assets/Frame1.png',
                      text: 'Reg end date',
                      controller: controller.rgEdDateController,
                      validator: (input) {
                        if (controller.date == null) {
                          Get.snackbar('Opps', "Date is required.",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        controller.selectDate(
                            context, controller.rgEdDateController);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      isReadOnly: true,
                      path: 'assets/Frame1.png',
                      text: 'Event Day',
                      controller: controller.eventDateController,
                      validator: (input) {
                        if (controller.date == null) {
                          Get.snackbar('Opps', "Date is required.",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        controller.selectDate(
                            context, controller.eventDateController);
                      },
                    ),
                    iconTitleContainer(
                        path: 'assets/#.png',
                        text: 'Max Entries',
                        controller: controller.maxEntries,
                        type: TextInputType.number,
                        onPress: () {
                          print('max entries');
                        },
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar('Opps', "Entries is required.",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                            return '';
                          }
                          return null;
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                iconTitleContainer(
                    path: 'assets/#.png',
                    text: 'Enter tags that will go with event.',
                    width: double.infinity,
                    controller: controller.tagsController,
                    onPress: () {
                      print('tags');
                    },
                    type: TextInputType.text,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Tags is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);

                        return;
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(width: 1, color: AppColors.genderTextColor),
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      Get.bottomSheet(StatefulBuilder(builder: (ctx, state) {
                        return Container(
                          width: double.infinity,
                          height: Get.width * 0.6,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.selectedFrequency.value = -1;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: controller.selectedFrequency
                                                      .value ==
                                                  -1
                                              ? Colors.blue
                                              : Colors.black.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Once",
                                            style: TextStyle(
                                                color: controller
                                                            .selectedFrequency
                                                            .value !=
                                                        -1
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  Obx(
                                    () => Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.selectedFrequency.value = 0;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: controller.selectedFrequency
                                                      .value ==
                                                  0
                                              ? Colors.blue
                                              : Colors.black.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Daily",
                                            style: TextStyle(
                                                color: controller
                                                            .selectedFrequency
                                                            .value !=
                                                        0
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  controller.selectedFrequency.value == 10
                                      ? Container()
                                      : const SizedBox(
                                          width: 10,
                                        ),
                                  Obx(
                                    () => Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.selectedFrequency.value = 1;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: controller.selectedFrequency
                                                      .value ==
                                                  1
                                              ? Colors.blue
                                              : Colors.black.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Weekly",
                                            style: TextStyle(
                                                color: controller
                                                            .selectedFrequency
                                                            .value !=
                                                        1
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  controller.selectedFrequency.value == 10
                                      ? Container()
                                      : const SizedBox(
                                          width: 10,
                                        ),
                                ],
                              ),
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceAround,
                                children: [
                                  controller.selectedFrequency.value == 10
                                      ? Container()
                                      : const SizedBox(
                                          width: 10,
                                        ),
                                  Obx(
                                    () => Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.selectedFrequency.value = 2;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: controller.selectedFrequency
                                                      .value ==
                                                  2
                                              ? Colors.blue
                                              : Colors.black.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Monthly",
                                            style: TextStyle(
                                                color: controller
                                                            .selectedFrequency
                                                            .value !=
                                                        2
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                  controller.selectedFrequency.value == 10
                                      ? Container()
                                      : const SizedBox(
                                          width: 10,
                                        ),
                                  Obx(
                                    () => Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        controller.selectedFrequency.value = 3;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: controller.selectedFrequency
                                                      .value ==
                                                  3
                                              ? Colors.blue
                                              : Colors.black.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Yearly",
                                            style: TextStyle(
                                                color: controller
                                                            .selectedFrequency
                                                            .value !=
                                                        3
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MaterialButton(
                                    minWidth: Get.width * 0.8,
                                    onPressed: () {
                                      controller.frequencyEventController
                                          .text = controller
                                                  .selectedFrequency.value ==
                                              -1
                                          ? 'Once'
                                          : controller.selectedFrequency
                                                      .value ==
                                                  0
                                              ? 'Daily'
                                              : controller.selectedFrequency
                                                          .value ==
                                                      1
                                                  ? 'Weekly'
                                                  : controller.selectedFrequency
                                                              .value ==
                                                          2
                                                      ? 'Monthly'
                                                      : 'Yearly';
                                      Get.back();
                                    },
                                    child: const Text(
                                      "Select",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      }));
                    },
                    validator: (String? input) {
                      if (input!.isEmpty) {
                        Get.snackbar('Opps', "Frequency is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    },
                    controller: controller.frequencyEventController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 3),
                      errorStyle: const TextStyle(fontSize: 0),
                      hintStyle: TextStyle(
                        color: AppColors.genderTextColor,
                      ),
                      border: InputBorder.none,
                      hintText: 'Frequency of event',
                      prefixIcon: Image.asset(
                        'assets/repeat.png',
                        cacheHeight: 20,
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                        path: 'assets/time.png',
                        text: 'Start Time',
                        controller: controller.startTimeController,
                        isReadOnly: true,
                        validator: (input) {},
                        onPress: () {
                          controller.startTimeMethod(context);
                        }),
                    iconTitleContainer(
                        path: 'assets/time.png',
                        text: 'End Time',
                        isReadOnly: true,
                        controller: controller.endTimeController,
                        validator: (input) {},
                        onPress: () {
                          controller.endTimeMethod(context);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    myText(
                        text: 'Description/Instruction',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 149,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(width: 1, color: AppColors.genderTextColor),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    controller: controller.descriptionController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        Get.snackbar('Opps', "Description is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(top: 25, left: 15, right: 15),
                      hintStyle: TextStyle(
                        color: AppColors.genderTextColor,
                      ),
                      hintText:
                          'Write a summary and any details your invitee should know about the event...',
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(8.0),
                      // ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Obx(() => controller.isCreatingEvent.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: 42,
                        width: double.infinity,
                        child: controller.isCreatingEvent.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : elevatedButton(
                                onPress: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (controller.media.isEmpty) {
                                    Get.snackbar('Opps', "Media is required.",
                                        colorText: Colors.white,
                                        backgroundColor: Colors.blue);

                                    return;
                                  }
                                  controller.createEvent();
                                },
                                text: 'Create Event'),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
