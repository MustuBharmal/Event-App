import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/user_model.dart';
import '../../../utils/app_color.dart';
import '../../auth/controller/auth_controller.dart';
import '../../home/bottom_bar_view.dart';

class ProfileController extends GetxController {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dob = TextEditingController();
  File? profileImage;
  int selectedRadio = 0;
  RxBool isLoading = RxBool(false);
  String image = '';
  RxBool isNotEditable = RxBool(true);
  UserModel? user;

  @override
  void onInit() {
    if (AuthController.instance.user.value != null) {
      fillProfileDetails();
    }
    super.onInit();
  }

  selectEventImage(List imgMedia) {
    try {
      List media = imgMedia;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      return mediaItem['url'];
    } catch (e) {
      return ('');
    }
  }

  fillProfileDetails() {
    firstNameController.text = AuthController.instance.user.value!.first!;
    lastNameController.text = AuthController.instance.user.value!.last!;
    image = AuthController.instance.user.value!.image!;
  }

  onSaveDetails() {
    isLoading(true);

    FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.instance.user.value!.uid!)
        .update({
      'first': firstNameController.text,
      'last': lastNameController.text,
    }).catchError(
      (onError) => {
        Get.snackbar('Error', 'Profile Update Failed',
            colorText: AppColors.white, backgroundColor: AppColors.blue),
      },
    );
    isLoading(false);
  }

  void setSelectedRadio(int val) {
    selectedRadio = val;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dob.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

  Future<void> addProfile() async {
    isLoading(true);
    try {
      String imageUrl = await AuthController.instance
          .uploadImageToFirebaseStorage(profileImage!);
      UserModel userModel = UserModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        image: imageUrl,
        first: firstNameController.text.trim(),
        last: lastNameController.text.trim(),
        dob: dob.text.trim(),
        gender: selectedRadio == 0 ? "Male" : "Female",
        userType: 'student',
        mobileNumber: mobileNumberController.text.trim(),
        joinedEvents: [],
        organizedEvents: [],
        email: emailController.text,
      );
      print(userModel.toJson());
      String uid = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userModel.toJson())
          .then((value) {
        Get.offAllNamed(BottomBarView.routeName);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
    isLoading(false);
  }

  imagePickDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    profileImage = File(image.path);
                    Get.back();
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    profileImage = File(image.path);
                    Get.back();
                  }
                },
                child: Image.asset(
                  'assets/gallary.png',
                  width: 25,
                  height: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
