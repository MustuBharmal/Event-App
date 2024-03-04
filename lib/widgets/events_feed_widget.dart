import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/views/auth/controller/auth_controller.dart';
import 'package:ems/views/home/controller/home_controller.dart';
import 'package:ems/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_color.dart';
import '../views/event_page/event_page_view.dart';

Widget eventsFeed() {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (ctx, i) {
      return eventItem(HomeController.instance.allEvents[i]);
    },
    itemCount: HomeController.instance.allEvents.length,
  );
}

Widget buildCard(
    {String? image, Function? func, required EventModel eventData}) {
  List joinedUsers = [];

  try {
    joinedUsers = eventData.joined;
  } catch (e) {
    joinedUsers = [];
  }

  List dateInformation = [];
  try {
    dateInformation = eventData.eventDay.toString().split('/');
  } catch (e) {
    dateInformation = [];
  }

  List userLikes = [];

  try {
    userLikes = eventData.likes;
  } catch (e) {
    userLikes = [];
  }

  List eventSavedByUsers = [];
  try {
    eventSavedByUsers = eventData.saves;
  } catch (e) {
    eventSavedByUsers = [];
  }
  return Container(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: const Color(0x000602d3).withOpacity(0.15),
          spreadRadius: 0.1,
          blurRadius: 2,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            func!();
          },
          child: Container(
            // child: Image.network(image!,fit: BoxFit.fill,),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image!), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10),
            ),

            width: double.infinity,
            height: Get.height * 0.6,
            //color: Colors.red,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: Get.width * 0.15,
                height: Get.height * 0.04,
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xffADD8E6))),
                child: Text(
                  '${dateInformation[0]} / ${dateInformation[1]}',
                  style: TextStyle(
                    fontSize: Get.height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                eventData.eventName,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (eventSavedByUsers
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData.id)
                        .set({
                      'saves': FieldValue.arrayRemove(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                    eventSavedByUsers
                        .remove(FirebaseAuth.instance.currentUser!.uid);
                  } else {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData.id)
                        .set({
                      'saves': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                    eventSavedByUsers
                        .add(FirebaseAuth.instance.currentUser!.uid);
                  }
                },
                child: SizedBox(
                  width: Get.width * 0.13,
                  height: Get.height * 0.029,
                  child: Image.asset(
                    'assets/bookMark.png',
                    fit: BoxFit.contain,
                    color: eventSavedByUsers
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
                width: Get.width * 0.6,
                height: 50,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    final user = HomeController.instance.listOfUser
                        .firstWhere((user) => user.uid == joinedUsers[index]);

                    return Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                        minRadius: 13,
                        backgroundImage: NetworkImage(user.image!),
                      ),
                    );
                  },
                  itemCount: joinedUsers.length,
                  scrollDirection: Axis.horizontal,
                )),
          ],
        ),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Row(
          children: [
            SizedBox(
              width: Get.width * 0.3,
            ),
            InkWell(
              onTap: () {
                if (userLikes
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData.id)
                      .set({
                    'likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                } else {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData.id)
                      .set({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                }
              },
              child: Container(
                height: 20,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffD24698).withOpacity(0.02),
                    )
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  size: Get.width * 0.07,
                  color:
                      userLikes.contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '${userLikes.length}',
              style: TextStyle(
                color: AppColors.black,
                fontSize: Get.width * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              padding: const EdgeInsets.all(0.5),
              width: Get.width * 0.06,
              // height: 16,
              child: Image.asset(
                'assets/send.png',
                fit: BoxFit.contain,
                color: AppColors.black,
                width: Get.width * 0.05,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

eventItem(EventModel event) {
  String eventImage = '';
  try {
    List media = event.media;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    eventImage = mediaItem['url'];
  } catch (e) {
    eventImage = '';
  }

  return Column(
    children: [
      // Row(
      //   children: [
      //     CircleAvatar(
      //       radius: 25,
      //       backgroundColor: Colors.blue,
      //       backgroundImage: NetworkImage(image),
      //     ),
      //     const SizedBox(
      //       width: 12,
      //     ),
      //     Text(
      //       '${user.get('first')} ${user.get('last')}',
      //       style:
      //           GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18),
      //     ),
      //   ],
      // ),
      // SizedBox(
      //   height: Get.height * 0.01,
      // ),
      buildCard(
          image: eventImage,
          eventData: event,
          func: () {
            Get.toNamed(EventPageView.routeName, arguments: event);
          }),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}

eventsIJoined() {
  return HomeController.instance.isLoading.value
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/doneCircle.png',
                    fit: BoxFit.cover,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'You\'re all caught up!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(
                            AuthController.instance.user.value!.image!),
                        backgroundImage: const AssetImage('assets/time.png'),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${AuthController.instance.user.value?.first} ${AuthController.instance.user.value?.last}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: const Color(0xff918F8F).withOpacity(0.2),
                  ),
                  ListView.builder(
                    itemCount: HomeController.instance.joinedEvents.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      String date =
                          HomeController.instance.joinedEvents[i].eventDay;
                      date = date.split('/')[0] + '-' + date.split('/')[1];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 41,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: const Color(0xffADD8E6),
                                    ),
                                  ),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.06,
                                ),
                                Text(
                                  HomeController
                                      .instance.joinedEvents[i].eventName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              width: Get.width * 0.6,
                              height: 50,
                              child: ListView.builder(
                                itemBuilder: (ctx, index) {
                                  if (HomeController.instance.joinedEvents[i]
                                      .joined.isEmpty) {
                                    return Container();
                                  }
                                  final user = HomeController
                                      .instance.listOfUser
                                      .firstWhere((user) =>
                                          user.uid ==
                                          HomeController.instance
                                              .joinedEvents[i].joined[index]);

                                  return Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      minRadius: 13,
                                      backgroundImage:
                                          NetworkImage(user.image!),
                                    ),
                                  );
                                },
                                itemCount: HomeController
                                    .instance.joinedEvents[i].joined.length,
                                scrollDirection: Axis.horizontal,
                              )),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
}
