import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/event_model.dart';
import '../../create_event/create_event.dart';
import '../../profile/profile.dart';
import '../home_screen.dart';

class HomeController extends GetxController {
  RxInt currentIndex = RxInt(0);

  static HomeController get instance => Get.find<HomeController>();

  RxList<EventModel> allEvents = <EventModel>[].obs;
  var filteredUsers = <DocumentSnapshot>[].obs;
  RxList<EventModel> filteredEvents = <EventModel>[].obs;
  RxList<EventModel> joinedEvents = <EventModel>[].obs;

  var isLoading = false.obs;
  RxList<UserModel> listOfUser = RxList.empty();
  RxBool isUser = RxBool(false);
  var isJoinedUser = false.obs;

  List<Widget> facultyWidgetOption = [
    const HomeView(),
    // const CommunityScreen(),

    const ProfileScreen(),
    CreateEventView()
  ];
  List<Widget> studentWidgetOption = [
    const HomeView(),
    // const CommunityScreen(),
    // CreateEventView(),
    const ProfileScreen()
  ];

  toCheckUserIsEnrolled(List<String> joined) {
    isJoinedUser.value =
        joined.contains(FirebaseAuth.instance.currentUser!.uid);
  }

  void onItemTapped(int index) {
    currentIndex.value = index;
  }

  /*sendMessageToFirebase({
    Map<String, dynamic>? data,
    String? lastMessage,
    String? groupId,
  }) async {
    isMessageSending(true);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(groupId)
        .collection('chatroom')
        .add(data!);
    await FirebaseFirestore.instance.collection('chats').doc(groupId).set({
      'lastMessage': lastMessage,
      'groupId': groupId,
      'group': groupId!.split('-'),
    }, SetOptions(merge: true));

    isMessageSending(false);
  }*/


  // createNotification(String recUid) {
  //   FirebaseFirestore.instance
  //       .collection('notifications')
  //       .doc(recUid)
  //       .collection('myNotifications')
  //       .add({
  //     'message': "Send you a message.",
  //     'image': user.value!.image,
  //     'name': user.value!.first! + " " + user.value!.last!,
  //     'time': DateTime.now()
  //   });
  // }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUsers();
    getEvents();
  }

  getUsers() {
    isLoading(true);
    listOfUser.clear();
    List<UserModel> result = [];
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      for (var userDoc in event.docs) {
        result.add(UserModel.fromSnapshot(userDoc));
      }
      listOfUser.value = result;
    });
    isLoading(false);
  }

  getEvents() async {
    isLoading(true);
    FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .listen((elements) {
      allEvents.clear();
      for (var element in elements.docs) {
        allEvents.add(EventModel.fromSnapshot(element));
        filteredEvents.assign(EventModel.fromSnapshot(element));
        joinedEvents.value = allEvents.where((e) {
          List<String> joinedIds = e.joined;
          return joinedIds.contains(FirebaseAuth.instance.currentUser!.uid);
        }).toList();
      }
    });
    isLoading(false);
  }
}
