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

import '../../auth/controller/auth_controller.dart';

class RegistrationController extends GetxController {
  TextEditingController teamNameController = TextEditingController();
  RxInt noOfParticipant = RxInt(0);
  List<GroupMemberModel> listOfEvent = [];
  GroupEventModel? groupEventModel;
  RxBool isLoading = RxBool(false);

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
