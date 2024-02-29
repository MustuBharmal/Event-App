import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_event_model.dart';
import 'package:ems/model/group_member_model.dart';
import 'package:ems/views/home/bottom_bar_view.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/event_model.dart';
import '../../../model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../home/controller/home_controller.dart';
String fileName = '';

class RegistrationController extends GetxController {
  var excel = Excel.createExcel();
  EventModel event = Get.arguments;
  TextEditingController teamNameController = TextEditingController();
  RxInt noOfParticipant = RxInt(0);
  List<GroupMemberModel> listOfEvent = [];
  GroupEventModel? groupEventModel;
  RxBool isLoading = RxBool(false);
  
  @override
  void onInit() {
    selectEventImage();
    super.onInit();
  }
  RxString eventImage = RxString('');
  
  Future<void> exportFireStoreDataToExcel(String collectionName) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    if (querySnapshot.docs.isNotEmpty) {
      final Excel excel = Excel.createExcel();
      final Sheet sheetObject = excel['Sheet1'];

      // Add headers to the Excel sheet
      List<String> headers = querySnapshot.docs.first.data().keys.toList();
      for (int col = 0; col < headers.length; col++) {
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: col + 1, rowIndex: 1))
            .value = headers[col] as CellValue?;
      }

      // Add data to the Excel sheet
      for (int row = 0; row < querySnapshot.docs.length; row++) {
        Map<String, dynamic> rowData = querySnapshot.docs[row].data();
        for (int col = 0; col < headers.length; col++) {
          sheetObject
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col + 1, rowIndex: row + 2))
              .value = rowData[headers[col]];
        }
      }

      // Save the Excel file
      final String path = (await getExternalStorageDirectory())!.path;
      final String fullPath = '$path/events_data.xlsx';

      // Use await to wait for the encoding to complete
      List<int>? excelBytes = excel.encode();
      File(fullPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(Uint8List.fromList(excelBytes!));

      print('Excel file created at: $fullPath');
    } else {
      print('No data found in the Firestore collection.');
    }
  }

  Future<void> joinedEvent({String? eventId}) async {
    try {
      FirebaseFirestore.instance.collection('events').doc(eventId).set({
        'joined':
            FieldValue.arrayUnion([AuthController.instance.user.value!.uid]),
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
  selectEventImage(){
    try {
      List media = event.media;
      Map mediaItem =
      media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = RxString('');
    }
  }
  // createGroupExcelSheet(){
  //   fileName = event.eventName.toUpperCase();
  //   Sheet sheet = excel[event.eventName];
  //   List<GroupEventModel> listofGroupEventParticipants = [];
  //
  // }
  // Future<void> generateExcelSheet(String eventId) async {
  //   final CollectionReference<Map<String, dynamic>> groupEventsCollection =
  //   FirebaseFirestore.instance.collection('your_collection_name');
  //
  //   DocumentSnapshot<Map<String, dynamic>> snapshot =
  //   await groupEventsCollection.doc(eventId).get();
  //
  //   if (snapshot.exists) {
  //     GroupEventModel groupEvent = GroupEventModel.fromSnapshot(snapshot);
  //
  //     final excel = Excel.createExcel();
  //     final sheet = excel['Sheet1'];
  //
  //     // Add headers
  //     sheet.appendRow([
  //       'Member Name',
  //       'Member Email',
  //       'Member Semester',
  //       'Member Department',
  //       'Member Number'
  //     ]);
  //
  //     // Add data for each member
  //     for (int i = 0; i < groupEvent.groupOfMembers.length; i++) {
  //       GroupMemberModel member = groupEvent.groupOfMembers[i];
  //       sheet.appendRow([
  //         member.membersName ?? '',
  //         member.membersEmail ?? '',
  //         member.membersSem ?? '',
  //         member.membersDept ?? '',
  //         member.membersNum ?? '',
  //       ]);
  //     }
  //
  //     // Save the Excel file
  //     final List<int> excelBytes = excel.encode();
  //     final Uint8List uint8List = Uint8List.fromList(excelBytes);
  //
  //     // Save the Excel file to device storage
  //     final Directory directory = await getExternalStorageDirectory();
  //     final String excelFilePath =
  //         '${directory.path}/group_event_excel.xlsx';
  //
  //     File(excelFilePath).writeAsBytesSync(uint8List);
  //   } else {
  //     print('Group event not found.');
  //   }
  // }

  createIndividualExcelSheet(){
    fileName = event.eventName.toUpperCase();
    //create an excel sheet
    Sheet sheet = excel[event.eventName];
    List<UserModel> listOfParticipatedUser = [];

    for(var user in HomeController.instance.listOfUser){
      var isCheck = event.joined.contains(user.uid);
      if(isCheck){
        listOfParticipatedUser.add(user);
      }
    }


    sheet.appendRow([const TextCellValue('Serial No'), const TextCellValue('Name'), const TextCellValue('Number'), const TextCellValue('Email'), const TextCellValue('Gender')]);
    for (int i = 0; i < event.joined.length; i++) {

      var index = sheet.cell(CellIndex.indexByString('A${i+2}'));
      var nameCell = sheet.cell(CellIndex.indexByString('B${i + 2}'));
      var number = sheet.cell(CellIndex.indexByString('C${i + 2}'));
      var email = sheet.cell(CellIndex.indexByString('D${i + 2}'));
      var gender = sheet.cell(CellIndex.indexByString('E${i + 2}'));
      index.value = TextCellValue("${i+1}");
      nameCell.value = TextCellValue(
          '${listOfParticipatedUser[i].first!} ${listOfParticipatedUser[i].last!}');
      number.value = TextCellValue('${listOfParticipatedUser[i].mobileNumber}');
      email.value = TextCellValue('${listOfParticipatedUser[i].email}');
      gender.value = TextCellValue('${listOfParticipatedUser[i].gender}');
    }
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
  Future<void> groupEventSubmit({String? eventId}) async {
    isLoading(true);

    groupEventModel = GroupEventModel(
      teamName: teamNameController.value.text,
      teamLeaderUid: AuthController.instance.user.value!.uid,
      groupOfMembers: listOfEvent,
    );
    FirebaseFirestore.instance.collection('events').doc(eventId).set({
      'joined':
          FieldValue.arrayUnion([AuthController.instance.user.value!.uid]),
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
  }
}
