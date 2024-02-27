import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_event_model.dart';
import 'package:ems/model/group_member_model.dart';
import 'package:ems/views/home/bottom_bar_view.dart';
import 'package:ems/views/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  TextEditingController teamNameController = TextEditingController();
  RxInt noOfParticipant = RxInt(0);
  List<GroupMemberModel> listOfEvent = [];
  GroupEventModel? groupEventModel;
  RxBool isLoading = RxBool(false);

  Future<void> joinedEvent({String? eventId}) async {
    try {
      FirebaseFirestore.instance.collection('events').doc(eventId).set({
        'joined':
            FieldValue.arrayUnion([HomeController.instance.user.value!.uid]),
        'max_entries': FieldValue.increment(-1),
      }, SetOptions(merge: true)).then((value) {
        Get.offAllNamed(BottomBarView.routeName);
        isLoading(false);
        Get.snackbar('Congratulations', 'You have joined success',
            colorText: Colors.white, backgroundColor: Colors.blue);
      });
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> groupEventSubmit({String? eventId}) async {
    isLoading(true);

    groupEventModel = GroupEventModel(
      teamName: teamNameController.value.text,
      teamLeaderUid: HomeController.instance.user.value!.uid,
      groupOfMembers: listOfEvent,
    );
    FirebaseFirestore.instance.collection('events').doc(eventId).set({
      'joined':
          FieldValue.arrayUnion([HomeController.instance.user.value!.uid]),
      'max_entries': FieldValue.increment(-1),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection('group_participants')
        .add(groupEventModel!.toJson())
        .then((value) {
      // resetControllers();
      Get.offAllNamed(BottomBarView.routeName);
      isLoading(false);
      Get.snackbar('Team registered', 'Team registered successfully.',
          colorText: Colors.white, backgroundColor: Colors.blue);
    }).catchError((e) {
      isLoading(false);
      print(e.toString());
      Get.snackbar('Warning', 'Team registered failed',
          colorText: Colors.white, backgroundColor: Colors.blue);
    });

    //
    // Future<void> groupEventSubmit() async {
    //   isLoading(true);
    //
    //   groupEventModel = GroupEventModel(
    //     teamName: teamNameController.value.toString(),
    //     groupOfMembers: listOfEvent,
    //   );
    //
    //   await FirebaseFirestore.instance
    //       .collection('groupEvent')
    //       .add(groupEventModel!.toJson())
    //         .then((value) {
    //     // resetControllers();
    //     Get.back();
    //     isLoading(false);
    //     Get.snackbar('Team registered', 'Team registered successfully.',
    //         colorText: Colors.white, backgroundColor: Colors.blue);
    //   }).catchError((e) {
    //     isLoading(false);
    //     print(e.toString());
    //     Get.snackbar('Warning', 'Team registered failed',
    //         colorText: Colors.white, backgroundColor: Colors.blue);
    //   });
    // }
  }
}
