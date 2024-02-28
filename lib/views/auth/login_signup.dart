import 'package:ems/views/auth/controller/auth_controller.dart';
import 'package:ems/views/profile/add_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class LoginView extends GetView<AuthController> {
  LoginView({Key? key}) : super(key: key);
  static const String routeName = '/login-view';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.08,
                ),
                controller.isSignUp.value
                    ? myText(
                        text: 'Sign Up',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : myText(
                        text: 'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                controller.isSignUp.value
                    ? Container(
                        child: myText(
                          text:
                              'Welcome, Please Sign up to see events and classes from your friends.',
                          style: GoogleFonts.roboto(
                            letterSpacing: 0,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        child: myText(
                          text:
                              'Welcome back, Please Sign in and continue your journey with us.',
                          style: GoogleFonts.roboto(
                            letterSpacing: 0,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                SizedBox(
                  width: Get.width * 0.55,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(Get.height * 0.01),
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    onTap: (v) {
                      controller.isSignUp.value = !controller.isSignUp.value;
                    },
                    tabs: [
                      myText(
                        text: 'Login',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black),
                      ),
                      myText(
                        text: 'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: Form(
                    key: formKey,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        loginWidget(),
                        signUpWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              myTextField(
                  obscure: false,
                  icon: 'assets/mail.png',
                  hintText: 'sarasmith12@gmail.com',
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar('Warning', 'Email is required.',
                          colorText: Colors.white,
                          backgroundColor: Colors.blue);
                      return '';
                    }

                    if (!input.contains('@')) {
                      Get.snackbar('Warning', 'Email is invalid.',
                          colorText: Colors.white,
                          backgroundColor: Colors.blue);
                      return '';
                    }
                  },
                  controller: controller.emailController),
              SizedBox(
                height: Get.height * 0.02,
              ),
              myTextField(
                  obscure: true,
                  icon: 'assets/lock.png',
                  hintText: 'password',
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar('Warning', 'Password is required.',
                          colorText: Colors.white,
                          backgroundColor: Colors.blue);
                      return '';
                    }

                    if (input.length < 6) {
                      Get.snackbar(
                          'Warning', 'Password should be 6+ characters.',
                          colorText: Colors.white,
                          backgroundColor: Colors.blue);
                      return '';
                    }
                  },
                  controller: controller.passwordController),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Forget Password?',
                      content: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            myTextField(
                                obscure: false,
                                icon: 'assets/lock.png',
                                hintText: 'enter your email...',
                                controller: controller.forgetEmailController),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              color: Colors.blue,
                              onPressed: () {
                                controller.forgetPassword(controller
                                    .forgetEmailController.text
                                    .trim());
                              },
                              child: const Text("Sent"),
                              minWidth: double.infinity,
                            )
                          ],
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                  ),
                  child: myText(
                      text: 'Forgot password?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      )),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
            width: Get.width,
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : elevatedButton(
                      text: 'Login',
                      onPress: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        controller.login();
                      },
                    ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myText(
            text: 'Or Connect With',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialAppsIcons(
                  text: 'assets/fb.png',
                  onPressed: () {
                    Get.to(() => AddProfileScreen());
                  }),
              socialAppsIcons(
                  text: 'assets/google.png',
                  onPressed: () {
                    controller.signInWithGoogle();
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget signUpWidget() {
    return SingleChildScrollView(
        child: Column(
      children: [
        myTextField(
            obscure: false,
            icon: 'assets/mail.png',
            hintText: 'Email',
            validator: (String input) {
              if (input.isEmpty) {
                Get.snackbar('Warning', 'Email is required.',
                    colorText: Colors.white, backgroundColor: Colors.blue);
                return '';
              }

              if (!input.contains('@')) {
                Get.snackbar('Warning', 'Email is invalid.',
                    colorText: Colors.white, backgroundColor: Colors.blue);
                return '';
              }
            },
            controller: controller.emailController),
        SizedBox(
          height: Get.height * 0.02,
        ),
        myTextField(
            obscure: true,
            icon: 'assets/lock.png',
            hintText: 'password',
            validator: (String input) {
              if (input.isEmpty) {
                Get.snackbar('Warning', 'Password is required.',
                    colorText: Colors.white, backgroundColor: Colors.blue);
                return '';
              }

              if (input.length < 6) {
                Get.snackbar('Warning', 'Password should be 6+ characters.',
                    colorText: Colors.white, backgroundColor: Colors.blue);
                return '';
              }
            },
            controller: controller.passwordController),
        SizedBox(
          height: Get.height * 0.02,
        ),
        myTextField(
            obscure: false,
            icon: 'assets/lock.png',
            hintText: 'Re-enter password',
            validator: (input) {
              if (input != controller.passwordController.text.trim()) {
                Get.snackbar(
                    'Warning', 'Confirm Password is not same as password.',
                    colorText: Colors.white, backgroundColor: Colors.blue);
                return '';
              }
            },
            controller: controller.confirmPasswordController),
        Obx(() => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: 50,
                margin: EdgeInsets.symmetric(
                  vertical: Get.height * 0.04,
                ),
                width: Get.width,
                child: elevatedButton(
                  text: 'Sign Up',
                  onPress: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    controller.signUp(
                        email: controller.emailController.text.trim(),
                        password: controller.passwordController.text.trim());
                  },
                ),
              )),
        myText(
          text: 'Or Connect With',
          style: TextStyle(
            fontSize: Get.height * 0.025,
          ),
        ),
        SizedBox(
          height: Get.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            socialAppsIcons(text: 'assets/fb.png', onPressed: () {}),
            socialAppsIcons(text: 'assets/google.png', onPressed: () {}),
          ],
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        SizedBox(
            width: Get.width * 0.8,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: [
                TextSpan(
                    text: 'By signing up, you agree our ',
                    style: TextStyle(color: Color(0xff262628), fontSize: 12)),
                TextSpan(
                  text: 'terms, Data policy and cookies policy',
                  style: TextStyle(
                    color: Color(0xff262628),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            )),
      ],
    ));
  }
}
