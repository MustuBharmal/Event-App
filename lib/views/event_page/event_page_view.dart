import 'package:ems/model/user_model.dart';
import 'package:ems/utils/date_formatter.dart';
import 'package:ems/views/auth/controller/auth_controller.dart';
import 'package:ems/views/event_page/event_participants_list_view.dart';
import 'package:ems/views/home/controller/home_controller.dart';
import 'package:ems/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_color.dart';
import '../invite_guest/invite_guest_screen.dart';

import '../registration/register_event_view.dart';
import 'view_event_end_details.dart';

class EventPageView extends StatelessWidget {
  static const String routeName = '/event-page-view';

  const EventPageView({super.key});

  @override
  Widget build(BuildContext context) {
    EventModel event = Get.arguments;
    UserModel user = HomeController.instance.listOfUser
        .firstWhere((user) => user.uid == event.uid);
    HomeController.instance.toCheckUserIsEnrolled(event.joined);

    String eventImage = '';
    try {
      List media = event.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }

    String tagsCollectively = '';

    for (var e in event.tags) {
      tagsCollectively += '#$e ';
    }
    DateTime nowTime = currentTime();
    DateTime regEndDate = formatDate(event.rgEdDate);
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
                      user.image!,
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
                        '${user.first} ${user.last}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                        color: const Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Text(
                          event.participantType,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                      '${event.startTime}',
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
                    event.eventName,
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
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
                    '${event.location}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    event.eventDay,
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
                  Expanded(
                    child: SizedBox(
                      height: Get.height * 0.058,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(EventParticipantListView.routeName);
                        },
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            UserModel user = HomeController.instance.listOfUser
                                .firstWhere(
                                    (e) => e.uid == event.joined[index]);

                            return Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: CircleAvatar(
                                minRadius: 13,
                                foregroundImage: user.image != ''
                                    ? NetworkImage(user.image!)
                                    : null,
                                backgroundImage: const AssetImage(
                                    'assets/Group 18341 (1).png'),
                              ),
                            );
                          },
                          itemCount: event.joined.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Visibility(
                    visible: !regEndDate.isBefore(nowTime),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${event.maxEntries} spots left!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: Get.width * 0.04,
                          ),
                        ),
                        Text(
                          "Reg. ends at ${event.rgEdDate}",
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
                      text: event.description,
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
                            ? {
                                Get.to(() => InviteGuest()),
                                Get.snackbar(
                                    'Exciting news', 'Upcoming feature',
                                    colorText: AppColors.white,
                                    backgroundColor: AppColors.blue)
                              }
                            : null;
                      },
                      child: Container(
                        height: Get.height * 0.058,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: !regEndDate.isBefore(nowTime)
                                ? AppColors.blue.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.9)),
                        child: Center(
                          child: Text(
                            !regEndDate.isBefore(nowTime)
                                ? "Invite Friends"
                                : "Reg. Closed",
                            style: TextStyle(
                              color: !regEndDate.isBefore(nowTime)
                                  ? AppColors.white
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
                  if (AuthController.instance.user.value!.uid == event.uid)
                    Visibility(
                      visible: (regEndDate.isBefore(nowTime)),
                      child: Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(ViewEndEventDetails.routeName, arguments: event);
                          },
                          child: Container(
                            height: Get.height * 0.058,
                            decoration: BoxDecoration(
                                color: AppColors.white,
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
                                horizontal: 5, vertical: 10),
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
                  /*if (AuthController.instance.user.value!.uid == event.uid)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AddParticipatingCommunity.routeName);
                        },
                        child: Container(
                          height: Get.height * 0.058,
                          decoration: BoxDecoration(
                              color: AppColors.white,
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
                              'Add Other Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                  if (AuthController.instance.user.value!.userType == 'student')
                    Visibility(
                      visible: !HomeController.instance.isJoinedUser.value &&
                          !regEndDate.isBefore(nowTime),
                      child: Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              RegisterEventView.routeName,
                              arguments: event,
                            );
                          },
                          child: Container(
                            height: Get.height * 0.058,
                            decoration: BoxDecoration(
                                color: AppColors.white,
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
                  const SizedBox(
                    width: 10,
                  ),
                  Visibility(
                    visible: HomeController.instance.isJoinedUser.value &&
                        !regEndDate.isBefore(nowTime) &&
                        AuthController.instance.user.value!.uid != event.uid,
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
                    event.likes.length.toString(),
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
                      'assets/bookMark.png',
                      fit: BoxFit.contain,
                      color: event.saves
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
