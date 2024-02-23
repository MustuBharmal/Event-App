import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/views/home/controller/home_controller.dart';
import 'package:ems/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../check_out/check_out_screen.dart';
import '../check_out/view_end_event_details.dart';
import '../invite_guest/invite_guest_screen.dart';
import 'package:intl/intl.dart';

class EventPageView extends StatelessWidget {
  final DocumentSnapshot user;
  final EventModel eventData;

  EventPageView(this.eventData, this.user, {super.key});

  HomeController dataController = Get.find<HomeController>();

  List eventSavedByUsers = [];

  @override
  Widget build(BuildContext context) {
    String image = '';
    dataController.toCheckUserIsEnrolled(eventData.joined);
    try {
      image = user.get('image');
    } catch (e) {
      image = '';
    }

    String eventImage = '';
    try {
      List media = eventData.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }

    List joinedUsers = [];

    try {
      joinedUsers = eventData.joined;
    } catch (e) {
      joinedUsers = [];
    }

    List tags = [];
    try {
      tags = eventData.tags;
    } catch (e) {
      tags = [];
    }

    String tagsCollectively = '';

    for (var e in tags) {
      tagsCollectively += '#$e ';
    }

    int likes = 0;

    try {
      likes = eventData.likes.length;
    } catch (e) {
      likes = 0;
    }
    DateFormat dFormat = DateFormat("dd/MM/yyyy");
    DateTime now = DateTime.now();
    DateTime regEndDate = dFormat.parse(eventData.rgEdDate);
    DateTime eventEndDate = dFormat.parse(eventData.eventDay);
    String dFormat2 = dFormat.format(now);
    DateTime nowTime = dFormat.parse(dFormat2);
    try {
      eventSavedByUsers = eventData.saves;
    } catch (e) {
      eventSavedByUsers = [];
    }
    // DateTime? d = DateTime.tryParse(widget.eventData.get('date'));

    // String formattedDate = formatDate(widget.eventData.get('date'));
    // log(formattedDate);
    // DateFormat("dd-MMM").format(formattedDate);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'assets/Header.png',
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      image,
                    ),
                    radius: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.get('first')} ${user.get('last')}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Text(
                      //   "${user.get('location')}",
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text(
                          eventData.event,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color(0xff0000FF), width: 1.5),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(
                      '${eventData.startTime}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    eventData.eventName,
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    eventData.eventDay,
                    // formattedDate,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/location.png',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${eventData.location}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: Get.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(eventImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.6,
                    height: Get.height * 0.058,
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        DocumentSnapshot user = dataController.allUsers
                            .firstWhere((e) => e.id == joinedUsers[index]);

                        String image = '';

                        try {
                          image = user.get('image');
                        } catch (e) {
                          image = '';
                        }

                        return Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            minRadius: 13,
                            backgroundImage: NetworkImage(image),
                          ),
                        );
                      },
                      itemCount: joinedUsers.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: !eventEndDate.isBefore(nowTime),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${eventData.maxEntries} spots left!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                        Text(
                          "Reg. ends at ${eventData.rgEdDate}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.width * 0.027,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: eventData.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        !regEndDate.isBefore(nowTime)
                            ? Get.to(() => const Inviteguest())
                            : null;
                      },
                      child: Container(
                        height: Get.height * 0.058,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: !regEndDate.isBefore(nowTime)
                                ? Colors.blue.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.9)),
                        child: Center(
                          child: Text(
                            !regEndDate.isBefore(nowTime)
                                ? "Invite Friends"
                                : "Reg. Closed",
                            style: TextStyle(
                              color: !regEndDate.isBefore(nowTime)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: eventEndDate.isBefore(nowTime),
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ViewEndEventDetails(eventData));
                        },
                        child: Container(
                          height: Get.height * 0.058,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 0.1,
                                  blurRadius: 60,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(13)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Center(
                            child: Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !dataController.isJoinedUser.value &&
                        !regEndDate.isBefore(nowTime),
                    child: Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.off(() => CheckOutView(eventData));
                        },
                        child: Container(
                          height: Get.height * 0.058,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 0.1,
                                  blurRadius: 60,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(13)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: const Center(
                            child: Text(
                              'Join',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: dataController.isJoinedUser.value &&
                        !regEndDate.isBefore(nowTime),
                    child: Expanded(
                      child: Container(
                        height: Get.height * 0.058,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0.1,
                                blurRadius: 60,
                                offset: const Offset(
                                    0, 1), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Center(
                          child: Text(
                            'Joined',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tagsCollectively,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.15,
                    height: 60,
                    child: Image.asset('assets/heart.png'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    likes.toString(),
                    style: TextStyle(
                      fontSize: Get.width * 0.05,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/send.png',
                    height: 16,
                    width: 16,
                  ),
                  const Spacer(),
                  SizedBox(
                    height: Get.height * 0.029,
                    width: Get.width * 0.2,
                    child: Image.asset(
                      'assets/boomMark.png',
                      fit: BoxFit.contain,
                      color: eventSavedByUsers
                              .contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
