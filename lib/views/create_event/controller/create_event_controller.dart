import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_community_model.dart';
import 'package:ems/views/home/controller/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../model/event_media_model.dart';
import '../../../model/event_model.dart';
import '../../../utils/app_color.dart';
import '../../auth/controller/auth_controller.dart';

class CreateEventController extends GetxController {
  TextEditingController eventDateController = TextEditingController();
  TextEditingController rgStDateController = TextEditingController();
  TextEditingController rgEdDateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController noOfParticipantController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController maxEntries = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController frequencyEventController = TextEditingController();
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);

  RxInt selectedFrequency = RxInt(-2);
  RxList<Map<String, dynamic>> mediaUrls = RxList([]);

  RxList<EventMediaModel> media = RxList([]);
  RxString participantType = RxString('All');
  RxString eventType = RxString('Individual');
  RxString accessModifier = RxString('Closed');

  List<String> participantTypeList = ['All', 'Faculty', 'Student'];
  List<String> eventTypeList = ['Individual', 'Group'];
  List<String> closeList = ['Closed', 'Open'];
  DateTime? date = DateTime.now();
  RxList<GroupCommunityModel> listOfCommunity = RxList.empty();
  RxBool isCreatingEvent = RxBool(false);
  RxInt noOfCommunity = RxInt(0);
  RxList<int> noOfMembers = RxList.empty();

  @override
  void onInit() {
    // TODO: implement onInit

    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    super.onInit();
  }

  Future<void> createEvent() async {
    isCreatingEvent(true);
    if (media.isNotEmpty) {
      for (int i = 0; i < media.length; i++) {
        if (media[i].isVideo!) {
          // / if video then first upload video file and then upload thumbnail and
          // / store it in the map

          String thumbnailUrl =
              await uploadThumbnailToFirebase(media[i].thumbnail!);

          String videoUrl = await uploadImageToFirebase(media[i].video!);

          mediaUrls.add(
              {'url': videoUrl, 'thumbnail': thumbnailUrl, 'isImage': false});
        } else {
          /// just upload image

          String imageUrl = await uploadImageToFirebase(media[i].image!);
          // uploadImageToFirebase(media[i].image!);
          mediaUrls.add({'url': imageUrl, 'isImage': true});
        }
      }
    }

    List<String> tags = tagsController.text.split(',');
    EventModel currEvent = EventModel(
      participantType: participantType.value,
      eventType: eventType.value,
      media: mediaUrls,
      noOfParticipant: int.parse(noOfParticipantController.text == ''
          ? '1'
          : noOfParticipantController.text),
      eventName: eventNameController.text,
      location: locationController.text,
      rgStDate: rgStDateController.text,
      rgEdDate: rgEdDateController.text,
      eventDay: eventDateController.text,
      maxEntries: int.parse(maxEntries.text),
      tags: tags,
      frequencyOfEvent: frequencyEventController.text,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      description: descriptionController.text,
      joined: [],
      uid: FirebaseAuth.instance.currentUser!.uid,
      inviter: [FirebaseAuth.instance.currentUser!.uid],
      likes: [],
      saves: [],
      createdAt: DateTime.now().toString(),
    );

    /*await createEvent(currEvent.toJson()).then((value) {
      isCreatingEvent(false);
      resetControllers();
    });*/
    await FirebaseFirestore.instance
        .collection('events')
        .add(currEvent.toJson())
        .then((value) async {
      FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.value!.uid)
          .set({
        'organizedEvents': FieldValue.arrayUnion([value.id]),
      }, SetOptions(merge: true));
      isCreatingEvent(false);
      HomeController.instance.allEvents
          .add(EventModel.fromSnapshot(await value.get()));
      HomeController.instance.getEvents();
      AuthController.instance.user.value!.organizedEvents?.add(value.id);
      resetControllers();
      Get.snackbar('Event Uploaded', 'Event is uploaded successfully.',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
    }).catchError((e) {
      isCreatingEvent(false);
      Get.snackbar('Warning', 'Event upload failed',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
    });
  }

  Future<String> uploadImageToFirebase(File file) async {
    String fileUrl = '';
    String fileName = path.basename(file.path);
    var reference =
        FirebaseStorage.instance.ref().child('eventImages/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      fileUrl = value;
    });
    return fileUrl;
  }

  void resetControllers() {
    media.value = [];
    eventDateController.clear();
    rgStDateController.clear();
    rgEdDateController.clear();
    noOfParticipantController.clear();
    timeController.clear();
    eventNameController.clear();
    locationController.clear();
    descriptionController.clear();
    tagsController.clear();
    maxEntries.clear();
    endTimeController.clear();
    startTimeController.clear();
    frequencyEventController.clear();
    noOfMembers.value = List.empty();
    noOfCommunity.value = 0;
    startTime = const TimeOfDay(hour: 0, minute: 0);
    endTime = const TimeOfDay(hour: 0, minute: 0);
  }

  selectDate(dateController) async {
    final DateTime? picked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      DateFormat dFormat = DateFormat("dd/MM/yyyy");
      String format = dFormat.format(date!);
      dateController.text = format;
    }
    return dateController;
  }

  Future<String> uploadThumbnailToFirebase(Uint8List file) async {
    String fileUrl = '';
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var reference =
        FirebaseStorage.instance.ref().child('myfiles/$fileName.jpg');
    UploadTask uploadTask = reference.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      fileUrl = value;
    });

    return fileUrl;
  }

  startTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour >= 12 ? 'PM' : 'AM'}';
    }
  }

  endTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      endTime = picked;
      endTimeController.text =
          '${endTime.hourOfPeriod > 9 ? "" : "0"}${endTime.hour > 9 ? "" : "0"}${endTime.hour > 12 ? '${endTime.hour - 12}' : endTime.hour}:${endTime.minute > 9 ? endTime.minute : '0${endTime.minute}'} ${endTime.hour >= 12 ? 'PM' : 'AM'}';
    }
  }

  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      imageQuality: 20,
      source: source,
    );

    if (image != null) {
      media.add(EventMediaModel(
          image: File(image.path), video: null, isVideo: false));
    }

    Get.back();
  }

  void imageDialog() {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      getImageDialog(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      getImageDialog(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: Get.context!);
  }
}
