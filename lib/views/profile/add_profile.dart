import 'package:ems/views/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class AddProfileScreen extends GetView<ProfileController> {
  static const String routeName = '/add-profile-screen';

  AddProfileScreen({super.key});

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.width * 0.1,
                ),
                InkWell(
                  onTap: () {
                    controller.imagePickDialog();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(70),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff7DDCFB),
                          Color(0xffBC67F2),
                          Color(0xffACF6AF),
                          Color(0xffF95549),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(70),
                          ),
                          child: controller.profileImage == null
                              ? const CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 56,
                                  backgroundColor: Colors.white,
                                  backgroundImage: FileImage(
                                    controller.profileImage!,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width * 0.1,
                ),
                textField(
                    text: 'First Name',
                    controller: controller.firstNameController,
                    validator: (String input) {
                      if (controller.firstNameController.text.isEmpty) {
                        Get.snackbar('Warning', 'First Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Last Name',
                    controller: controller.lastNameController,
                    validator: (String input) {
                      if (controller.lastNameController.text.isEmpty) {
                        Get.snackbar('Warning', 'Last Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Mobile Number',
                    inputType: TextInputType.phone,
                    controller: controller.mobileNumberController,
                    validator: (String input) {
                      if (controller.mobileNumberController.text.isEmpty) {
                        Get.snackbar('Warning', 'First Name is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (controller.mobileNumberController.text.length < 10) {
                        Get.snackbar('Warning', 'Enter valid phone number.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                textField(
                    text: 'Email',
                    inputType: TextInputType.emailAddress,
                    controller: controller.emailController,
                    validator: (String input) {
                      if (controller.emailController.text.isEmpty) {
                        Get.snackbar('Warning', 'Email is required.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (controller.emailController.text.length < 5) {
                        Get.snackbar('Warning', 'Enter valid email address.',
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                    }),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: controller.dob,
                    // enabled: false,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      controller.selectDate(context);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 10, left: 10),
                      suffixIcon: Image.asset(
                        'assets/calender.png',
                        cacheHeight: 20,
                      ),
                      hintText: 'Date Of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: RadioListTile(
                      title: Text(
                        'Male',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          color: AppColors.genderTextColor,
                        ),
                      ),
                      value: 0,
                      groupValue: controller.selectedRadio,
                      onChanged: (int? val) {
                        controller.setSelectedRadio(val!);
                      },
                    )),
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          'Female',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: AppColors.genderTextColor,
                          ),
                        ),
                        value: 1,
                        groupValue: controller.selectedRadio,
                        onChanged: (int? val) {
                          controller.setSelectedRadio(val!);
                        },
                      ),
                    ),
                  ],
                ),
                Obx(() => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 50,
                        margin: EdgeInsets.only(top: Get.height * 0.02),
                        width: Get.width,
                        child: elevatedButton(
                            text: 'Save',
                            onPress: () async {
                              if (controller.dob.text.isEmpty) {
                                Get.snackbar(
                                    'Warning', "Date of birth is required.",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }

                              if (!formKey.currentState!.validate()) {
                                return null;
                              }
                              if (controller.profileImage == null) {
                                Get.snackbar('Warning', "Image is required.",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);
                                return '';
                              }
                              controller.addProfile();
                            }),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                SizedBox(
                    width: Get.width * 0.8,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'By signing up, you agree our ',
                            style: TextStyle(
                                color: Color(0xff262628), fontSize: 12)),
                        TextSpan(
                            text: 'terms, Data policy and cookies policy',
                            style: TextStyle(
                                color: Color(0xff262628),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
