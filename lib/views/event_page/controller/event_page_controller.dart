import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/event_model.dart';
import 'package:ems/model/event_participant_model.dart';
import 'package:ems/model/group_event_model.dart';
import 'package:ems/utils/app_color.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../home/bottom_bar_view.dart';

String fileName = '';

class EventPageController extends GetxController {
  var excel = Excel.createExcel();
  EventModel? event;
  String? eventType;
  RxString eventImage = RxString('');
  RxList<String> joined = RxList.empty();
  List<GroupEventModel> listOfParticipatedTeam = [];
  List<IndividualParticipantModel> listOfParticipants = [];
  RxList<GroupEventModel> listOfGroupParticipants = RxList.empty();
  RxBool check = RxBool(false);
  RxList<IndividualParticipantModel> listOfIndividualParticipants =
      RxList.empty();
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    fillDetails();

    super.onInit();
  }

  selectEventImage() {
    try {
      event!.eventType == 'Individual'
          ? firebaseFunIndividual()
          : firebaseFunGroup();
      List? media = event?.media;
      Map mediaItem =
          media?.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage.value = mediaItem['url'];
    } catch (e) {
      eventImage = RxString('');
    }
  }

  setBool(bool value) {
    check.value = value;
  }

  fetchListOfUsersJoined(String dbName) {
    FirebaseFirestore.instance
        .collection(dbName)
        .where('event_id', isEqualTo: event!.id)
        .snapshots()
        .listen((participants) {
      for (var docs in participants.docs) {
        if (dbName == 'group_participants') {
          listOfGroupParticipants.add(GroupEventModel.fromSnapshot(docs));
        } else {
          listOfIndividualParticipants
              .add(IndividualParticipantModel.fromSnapshot(docs));
        }
      }
    });
  }

  fillDetails() {
    event = Get.arguments;
    if (event!.joined.isEmpty) {
      joined.value = RxList.empty();
    } else {
      joined.value = event!.joined;
      if (event!.eventType == 'Group') {
        fetchListOfUsersJoined('group_participants');
      } else {
        fetchListOfUsersJoined('individual_participants');
      }
    }
    selectEventImage();
  }

  fireBaseIndividualFunUpdateAttendance() async {
    isLoading.value = true;
    for (int i = 0; i < listOfIndividualParticipants.length; i++) {
      FirebaseFirestore.instance
          .collection('individual_participants')
          .doc(listOfIndividualParticipants[i].docId)
          .update(listOfIndividualParticipants[i].toJson())
          .catchError((e) => {
                isLoading.value = false,
                Get.snackbar('Error', 'Attendance update failed',
                    colorText: AppColors.white,
                    backgroundColor: AppColors.blue),
              });
    }
    isLoading.value = false;
    Get.snackbar('Success', 'Attendance updated!',
        colorText: AppColors.white, backgroundColor: AppColors.blue);
  }

  fireBaseGroupFunUpdateAttendance() async {
    isLoading.value = true;
    for (int i = 0; i < listOfIndividualParticipants.length; i++) {
      FirebaseFirestore.instance
          .collection('group_participants')
          .doc(listOfGroupParticipants[i].docId)
          .update(listOfGroupParticipants[i].toJson())
          .catchError((e) => {
                isLoading.value = false,
                Get.snackbar('Error', 'Attendance update failed',
                    colorText: AppColors.white,
                    backgroundColor: AppColors.blue),
              });
    }
    isLoading.value = false;
    Get.snackbar('Success', 'Attendance updated!',
        colorText: AppColors.white, backgroundColor: AppColors.blue);
  }

  firebaseFunGroup() {
    List<GroupEventModel> temp = [];
    FirebaseFirestore.instance
        .collection('group_participants')
        .where('event_id', isEqualTo: event!.id)
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
    List<IndividualParticipantModel> temp = [];
    FirebaseFirestore.instance
        .collection('individual_participants')
        .where('event_id', isEqualTo: event!.id)
        .snapshots()
        .listen((doc) {
      for (var data in doc.docs) {
        if (data.exists) {
          temp.add(IndividualParticipantModel.fromSnapshot(data));
        }
      }
      listOfParticipants = temp;
    });
  }

  individualExcelSheet() {
    isLoading(true);
    fileName = event!.eventName.toUpperCase();
    Sheet sheet = excel[event!.eventName];
    sheet.appendRow([
      const TextCellValue('Serial No'),
      const TextCellValue('Name'),
      const TextCellValue('Number'),
      const TextCellValue('Email'),
      const TextCellValue('Faculty'),
      const TextCellValue('Dept'),
      const TextCellValue('Sem'),
      const TextCellValue('Attendance'),
    ]);
    for (int i = 0; i < listOfParticipants.length; i++) {
      var index = sheet.cell(CellIndex.indexByString('A${i + 2}'));
      var nameCell = sheet.cell(CellIndex.indexByString('B${i + 2}'));
      var number = sheet.cell(CellIndex.indexByString('C${i + 2}'));
      var email = sheet.cell(CellIndex.indexByString('D${i + 2}'));
      var faculty = sheet.cell(CellIndex.indexByString('E${i + 2}'));
      var dept = sheet.cell(CellIndex.indexByString('F${i + 2}'));
      var sem = sheet.cell(CellIndex.indexByString('G${i + 2}'));
      var attendance = sheet.cell(CellIndex.indexByString('H${i + 2}'));
      index.value = TextCellValue("${i + 1}");
      nameCell.value = TextCellValue('${listOfParticipants[i].membersName}');
      number.value = TextCellValue('${listOfParticipants[i].membersNum}');
      email.value = TextCellValue('${listOfParticipants[i].membersEmail}');
      faculty.value = TextCellValue('${listOfParticipants[i].membersFaculty}');
      dept.value = TextCellValue('${listOfParticipants[i].membersDept}');
      sem.value = TextCellValue('${listOfParticipants[i].membersSem}');
      attendance.value = TextCellValue('${listOfParticipants[i].attendance}');
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
    fileName = event!.eventName.toUpperCase();
    Sheet sheet = excel[event!.eventName];

    sheet.appendRow([
      const TextCellValue('Team No'),
      const TextCellValue('Team Name'),
      const TextCellValue('Name'),
      const TextCellValue('Number'),
      const TextCellValue('Email'),
      const TextCellValue('Faculty'),
      const TextCellValue('Dept'),
      const TextCellValue('Sem'),
      const TextCellValue('Attendance'),
    ]);
    int k = 0;
    for (int i = 0; i < listOfParticipatedTeam.length; i++) {
      int j;
      var teamNoCell = sheet.cell(CellIndex.indexByString('A${i + k + 2}'));
      var teamNameCell = sheet.cell(CellIndex.indexByString('B${i + k + 2}'));
      var nameCell = sheet.cell(CellIndex.indexByString('C${i + k + 2}'));
      var numberCell = sheet.cell(CellIndex.indexByString('D${i + k + 2}'));
      var emailCell = sheet.cell(CellIndex.indexByString('E${i + k + 2}'));
      var faculty = sheet.cell(CellIndex.indexByString('F${i + 2}'));
      var dept = sheet.cell(CellIndex.indexByString('G${i + 2}'));
      var sem = sheet.cell(CellIndex.indexByString('H${i + 2}'));
      var attendance = sheet.cell(CellIndex.indexByString('I${i + 2}'));
      teamNoCell.value = TextCellValue("${i + 1}");
      teamNameCell.value = TextCellValue(listOfParticipatedTeam[i].teamName!);
      nameCell.value =
          TextCellValue(listOfParticipatedTeam[i].leaderDetail.membersName!);
      numberCell.value =
          TextCellValue('${listOfParticipatedTeam[i].leaderDetail.membersNum}');
      emailCell.value = TextCellValue(
          '${listOfParticipatedTeam[i].leaderDetail.membersEmail}');
      faculty.value = TextCellValue(
          '${listOfParticipatedTeam[i].leaderDetail.membersFaculty}');
      dept.value = TextCellValue(
          '${listOfParticipatedTeam[i].leaderDetail.membersDept}');
      sem.value =
          TextCellValue('${listOfParticipatedTeam[i].leaderDetail.membersSem}');
      attendance.value =
          TextCellValue('${listOfParticipatedTeam[i].attendance}');
      for (j = 0; j < listOfParticipatedTeam[i].groupOfMembers.length; j++) {
        var nameCell = sheet.cell(CellIndex.indexByString('C${i + k + 3}'));
        var numberCell = sheet.cell(CellIndex.indexByString('D${i + k + 3}'));
        var emailCell = sheet.cell(CellIndex.indexByString('E${i + k + 3}'));
        var faculty = sheet.cell(CellIndex.indexByString('F${i + 2}'));
        var dept = sheet.cell(CellIndex.indexByString('G${i + 2}'));
        var sem = sheet.cell(CellIndex.indexByString('H${i + 2}'));
        nameCell.value = TextCellValue(
            listOfParticipatedTeam[i].groupOfMembers[j].membersName!);
        numberCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersNum}');
        emailCell.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersEmail}');
        faculty.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersFaculty}');
        dept.value = TextCellValue(
            '${listOfParticipatedTeam[i].groupOfMembers[j].membersDept}');
        sem.value = TextCellValue(
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
