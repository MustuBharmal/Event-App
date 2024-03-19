import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_event_model.dart';
import 'package:ems/model/event_participant_model.dart';
import 'package:ems/utils/app_color.dart';
import 'package:ems/utils/log_util.dart';
import 'package:ems/views/home/bottom_bar_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/event_model.dart';
import '../../../model/ticket_model.dart';
import '../../auth/controller/auth_controller.dart';

class RegistrationController extends GetxController {
  EventModel event = Get.arguments;
  final leaderSem = TextEditingController();
  TextEditingController leaderDept = TextEditingController();
  final leaderEmail = TextEditingController();
  final leaderNum = TextEditingController();
  final leaderName = TextEditingController();
  TextEditingController teamNameController = TextEditingController();

  RxInt noOfParticipant = RxInt(0);
  List<IndividualParticipantModel> listOfGroupMembers = [];
  GroupEventModel? groupEventModel;
  RxBool isLoading = RxBool(false);

  RxList<FacultyDept> listOfFaculty = RxList.empty();
  Rx<FacultyDept?> facultyModifier = Rx<FacultyDept?>(null);
  Rx<String?> departmentModifier = Rx<String?>(null);

  @override
  void onInit() {
    leaderEmail.text = AuthController.instance.user.value!.email!;
    leaderName.text = AuthController.instance.user.value!.first!;
    leaderNum.text = AuthController.instance.user.value!.mobileNumber!;
    fetchData();
    super.onInit();
  }

  setFaculty(FacultyDept? singleFaculty) {
    facultyModifier.value = singleFaculty;
    departmentModifier.value = null;
  }

  setDepartment(String? singleDept) {
    departmentModifier.value = singleDept;
    // LogUtil.debug(departmentModifier.value);
  }

  setFunction() {}

  Future<void> fetchData() async {
    try {
      final jsonText = await rootBundle.loadString('assets/faculty-dept.json');
      final jsonData = json.decode(jsonText);
      List<FacultyDept> stateList = [];

      for (var facultyData in jsonData['faculties']) {
        final stateName = facultyData['faculty'];
        final districts = List<String>.from(facultyData['dept']);
        stateList.add(FacultyDept(stateName, districts));
      }
      listOfFaculty.value = stateList;
      // LogUtil.debug(listOfFaculty.length);
    } catch (e) {
      throw Exception('Failed to load data; $e');
    }
  }

  void resetControllers() {
    leaderSem.clear();
    leaderName.clear();
    leaderNum.clear();
    leaderDept.clear();
    leaderEmail.clear();
    teamNameController.clear();
    groupEventModel = null;
  }

  Future<void> groupEventSubmit() async {
    isLoading(true);
    IndividualParticipantModel leaderModel;
    leaderModel = IndividualParticipantModel(
      membersName: leaderName.text,
      membersNum: leaderNum.text,
      membersDept: departmentModifier.value,
      membersSem: leaderSem.text,
      membersEmail: leaderEmail.text,
      membersFaculty: facultyModifier.value?.faculty,

    );
    groupEventModel = GroupEventModel(
      eventId: event.id,
      teamName: teamNameController.value.text.capitalizeFirst,
      teamLeaderUid: AuthController.instance.user.value!.uid,
      leaderDetail: leaderModel,
      groupOfMembers: listOfGroupMembers,
      createdAt: DateTime.now().toString(),
      attendance: RxBool(false),
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.instance.user.value!.uid)
        .set({
      'joinedEvents': FieldValue.arrayUnion([event.id]),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance.collection('events').doc(event.id).set({
      'joined':
          FieldValue.arrayUnion([AuthController.instance.user.value!.uid]),
      'max_entries': FieldValue.increment(-1),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection('group_participants')
        .add(groupEventModel!.toJson())
        .then((value) {
      resetControllers();
      Get.offAllNamed(BottomBarView.routeName);
      isLoading(false);
      Get.snackbar('Team registered', 'Team registered successfully.',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
    }).catchError((e) {
      isLoading(false);
      LogUtil.warning(e.toString());
      Get.snackbar('Warning', 'Team registered failed',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
    });
  }

  Future<void> individualEventSubmit() async {
    isLoading(true);
    try {
      IndividualParticipantModel participant;
      participant = IndividualParticipantModel(
        eventId: event.id,
        membersUid: AuthController.instance.user.value!.uid,
        membersName: leaderName.text,
        membersNum: leaderNum.text,
        membersDept: departmentModifier.value,
        membersSem: leaderSem.text,
        membersEmail: leaderEmail.text,
        membersFaculty: facultyModifier.value!.faculty,
        createdAt: DateTime.now().toString(),
        attendance: RxBool(false),
      );
      LogUtil.debug(participant.toJson());
      FirebaseFirestore.instance
          .collection('individual_participants')
          .add(participant.toJson());
      FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.value!.uid)
          .set({
        'joinedEvents': FieldValue.arrayUnion([event.id]),
      }, SetOptions(merge: true));
      FirebaseFirestore.instance.collection('events').doc(event.id).set({
        'joined':
            FieldValue.arrayUnion([AuthController.instance.user.value!.uid]),
        'max_entries': FieldValue.increment(-1),
      }, SetOptions(merge: true)).then((value) {
        resetControllers();
        Get.offAllNamed(BottomBarView.routeName);
        isLoading(false);
        Get.snackbar('Congratulations', 'You have joined successfully',
            colorText: AppColors.white, backgroundColor: AppColors.blue);
      });
    } catch (e) {
      LogUtil.debug(e.toString());
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
