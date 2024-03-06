import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_event_model.dart';
import 'package:ems/model/event_participant_model.dart';
import 'package:ems/utils/app_color.dart';
import 'package:ems/views/home/bottom_bar_view.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/event_model.dart';
import '../../auth/controller/auth_controller.dart';

String fileName = '';

class RegistrationController extends GetxController {
  var excel = Excel.createExcel();
  EventModel event = Get.arguments;
  final leaderSem = TextEditingController();
  final leaderDept = TextEditingController();
  final leaderEmail = TextEditingController();
  final leaderNum = TextEditingController();
  final leaderName = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  List<GroupEventModel> listOfParticipatedTeam = [];
  List<EventParticipantModel> listOfParticipants = [];
  RxInt noOfParticipant = RxInt(0);
  List<EventParticipantModel> listOfEvent = [];
  GroupEventModel? groupEventModel;
  RxBool isLoading = RxBool(false);
  RxString eventImage = RxString('');

  @override
  void onInit() {
    selectEventImage();
    leaderEmail.text = AuthController.instance.user.value!.email!;
    event.eventType == 'Individual' ? firebaseFunIndividual() : firebaseFunGroup();
    super.onInit();
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

  firebaseFunGroup() {
    List<GroupEventModel> temp = [];
    FirebaseFirestore.instance
        .collection('group_participants')
        .where('event_id', isEqualTo: event.id)
        .snapshots()
        .listen((doc) {
      for (var data in doc.docs) {
        if (data.exists) {
          temp.add(GroupEventModel.fromSnapshot(data));
        }
      }
      listOfParticipatedTeam = temp;
    });
  }

  firebaseFunIndividual() {
    List<EventParticipantModel> temp = [];
    FirebaseFirestore.instance
        .collection('individual_participants')
        .where('event_id', isEqualTo: event.id)
        .snapshots()
        .listen((doc) {
      for (var data in doc.docs) {
        if (data.exists) {
          temp.add(EventParticipantModel.fromSnapshot(data));
        }
      }
      listOfParticipants = temp;
      print(listOfParticipants[0].membersSem);
    });
  }

  Future<void> groupEventSubmit() async {
    isLoading(true);
    EventParticipantModel leaderModel;
    leaderModel = EventParticipantModel(
      membersName: leaderName.text,
      membersNum: leaderNum.text,
      membersDept: leaderDept.text,
      membersSem: leaderSem.text,
      membersEmail: leaderEmail.text,
    );
    groupEventModel = GroupEventModel(
      eventId: event.id,
      teamName: teamNameController.value.text.capitalizeFirst,
      teamLeaderUid: AuthController.instance.user.value!.uid,
      leaderDetail: leaderModel,
      groupOfMembers: listOfEvent,
      createdAt: DateTime.now().toString(),
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
      print(e.toString());
      Get.snackbar('Warning', 'Team registered failed',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
    });
  }

  Future<void> individualEventSubmit() async {
    isLoading(true);
    try {
      EventParticipantModel participant;
      participant = EventParticipantModel(
        eventId: event.id,
        membersName: leaderName.text,
        membersNum: leaderNum.text,
        membersDept: leaderDept.text,
        membersSem: leaderSem.text,
        membersEmail: leaderEmail.text,
        createdAt: DateTime.now().toString(),
      );
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
      log(e.toString());
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  selectEventImage() {
    try {
      List media = event.media;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage.value = mediaItem['url'];
    } catch (e) {
      eventImage = RxString('');
    }
  }

  individualExcelSheet() {
    isLoading(true);
    fileName = event.eventName.toUpperCase();
    Sheet sheet = excel[event.eventName];
    sheet.appendRow([
      const TextCellValue('Serial No'),
      const TextCellValue('Name'),
      const TextCellValue('Number'),
      const TextCellValue('Email'),
      const TextCellValue('Dept'),
      const TextCellValue('Sem'),
    ]);
    for (int i = 0; i < listOfParticipants.length; i++) {
      var index = sheet.cell(CellIndex.indexByString('A${i + 2}'));
      var nameCell = sheet.cell(CellIndex.indexByString('B${i + 2}'));
      var number = sheet.cell(CellIndex.indexByString('C${i + 2}'));
      var email = sheet.cell(CellIndex.indexByString('D${i + 2}'));
      var dept = sheet.cell(CellIndex.indexByString('E${i + 2}'));
      var sem = sheet.cell(CellIndex.indexByString('F${i + 2}'));
      index.value = TextCellValue("${i + 1}");
      print(listOfParticipants[0].membersName);
      print(i);
      nameCell.value = TextCellValue('${listOfParticipants[i].membersName}');
      number.value = TextCellValue('${listOfParticipants[i].membersNum}');
      email.value = TextCellValue('${listOfParticipants[i].membersEmail}');
      dept.value = TextCellValue('${listOfParticipants[i].membersDept}');
      sem.value = TextCellValue('${listOfParticipants[i].membersSem}');
    }
    Get.offAllNamed(BottomBarView.routeName);
    Get.snackbar('Complete', 'Excel sheet is downloaded',
        colorText: AppColors.white, backgroundColor: AppColors.blue);
    isLoading(false);
  }

  Future<File> writeCounter(Excel excel) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    final file = await _localFile;
    return file.writeAsBytes(excel.encode()!);
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName.xlsx');
  }

  Future<String> get _localPath async {
    final directory = Directory("/storage/emulated/0/Download");
    return directory.path;
  }

  Future<void> groupEventExcelSheet() async {
    isLoading(true);
    fileName = event.eventName.toUpperCase();
    Sheet sheet = excel[event.eventName];

    sheet.appendRow([
      const TextCellValue('Team No'),
      const TextCellValue('Team Name'),
      const TextCellValue('Name'),
      const TextCellValue('Number'),
      const TextCellValue('Email'),
      const TextCellValue('Dept'),
      const TextCellValue('Sem'),
    ]);
    int k = 0;
    for (int i = 0; i < listOfParticipatedTeam.length; i++) {
      int j;
      var teamNoCell = sheet.cell(CellIndex.indexByString('A${i + k + 2}'));
      var teamNameCell = sheet.cell(CellIndex.indexByString('B${i + k + 2}'));
      var nameCell = sheet.cell(CellIndex.indexByString('C${i + k + 2}'));
      var numberCell = sheet.cell(CellIndex.indexByString('D${i + k + 2}'));
      var emailCell = sheet.cell(CellIndex.indexByString('E${i + k + 2}'));
      var deptCell = sheet.cell(CellIndex.indexByString('F${i + k + 2}'));
      var semCell = sheet.cell(CellIndex.indexByString('G${i + k + 2}'));
      teamNoCell.value = TextCellValue("${i + 1}");
      teamNameCell.value = TextCellValue(listOfParticipatedTeam[i].teamName!);
      nameCell.value =
          TextCellValue(listOfParticipatedTeam[i].leaderDetail.membersName!);
      numberCell.value =
          TextCellValue('${listOfParticipatedTeam[i].leaderDetail.membersNum}');
      emailCell.value = TextCellValue(
          '${listOfParticipatedTeam[i].leaderDetail.membersEmail}');
      deptCell.value = TextCellValue(
          '${listOfParticipatedTeam[i].leaderDetail.membersDept}');
      semCell.value =
          TextCellValue('${listOfParticipatedTeam[i].leaderDetail.membersSem}');
      for (j = 0; j < listOfParticipatedTeam[i].groupOfMembers.length; j++) {
        var nameCell = sheet.cell(CellIndex.indexByString('C${i + k + 3}'));
        var numberCell = sheet.cell(CellIndex.indexByString('D${i + k + 3}'));
        var emailCell = sheet.cell(CellIndex.indexByString('E${i + k + 3}'));
        var deptCell = sheet.cell(CellIndex.indexByString('F${i + k + 3}'));
        var semCell = sheet.cell(CellIndex.indexByString('G${i + k + 3}'));
        nameCell.value = TextCellValue(
            listOfParticipatedTeam[i].groupOfMembers[j].membersName!);
        numberCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersNum}');
        emailCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersEmail}');
        deptCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersDept}');
        semCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersSem}');
        k++;
      }
    }
    Get.offAllNamed(BottomBarView.routeName);
    Get.snackbar('Complete', 'Excel sheet is downloaded',
        colorText: AppColors.white, backgroundColor: AppColors.blue);
    isLoading(false);
  }
}
