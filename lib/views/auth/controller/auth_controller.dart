import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/utils/log_util.dart';
import 'package:ems/views/auth/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../model/user_model.dart';
import '../../../utils/app_color.dart';
import '../../home/bottom_bar_view.dart';
import '../../profile/add_profile.dart';
import 'package:path/path.dart' as path;

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedRadio = 0;
  Rx<UserModel?> user = Rx(null);
  RxBool isSignUp = RxBool(false);
  TextEditingController forgetEmailController = TextEditingController();
  RxBool isLoading = RxBool(false);
  RxBool isLogoutLoading = RxBool(false);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    forgetEmailController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    checkLogin();
    super.onInit();
  }

  void setSelectedRadio(int val) {
    selectedRadio = val;
  }

  logout() {
    isLogoutLoading(true);
    try {
      FirebaseAuth.instance.signOut();
      Get.offAllNamed(LoginView.routeName);
      // user.value = null;
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
    isLogoutLoading(false);
  }

  checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (FirebaseAuth.instance.currentUser == null) {
      Get.offNamed(LoginView.routeName);
      // Get.to(() => const OnBoardingScreen());
    } else {
      getCurrUsr();
    }
  }

  getCurrUsr() async {
    try {
      var currUsr = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (currUsr.exists) {
        user.value = UserModel.fromSnapshot(currUsr);
        Get.offNamed(BottomBarView.routeName);
      } else {
        Get.offNamed(AddProfileScreen.routeName);
      }

      isLoading(false);
      clearControllers();
    } catch (e) {
      LogUtil.debug(e.toString());
    }
    isLoading(false);
  }

  clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    forgetEmailController.clear();
  }

  void login() async {
    isLoading(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      getCurrUsr();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        isLoading(false);
        Get.snackbar("Error", "Invalid Credential");
      }
    }
  }

  void signUp({String? email, String? password}) {
    isLoading(true);
    AuthController.instance.user.value = null;
    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      isLoading(false);

      /// Navigate user to profile screen
      Get.toNamed(AddProfileScreen.routeName);
    }).catchError((e) {
      /// print error information
      log("Error in authentication $e");
      isLoading(false);
    });
  }

  void forgetPassword() {
    auth
        .sendPasswordResetEmail(email: forgetEmailController.text.trim())
        .then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      log("Error in sending password reset email is $e");
    });
  }

  Future<void> signInWithGoogle() async {
    isLoading(true);
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Once signed in, return the UserCredential
    } catch (e) {
      Get.snackbar('error', 'Something went wrong, (Check Internet)');
      isLoading(false);
      throw ('\n signInFromGoogle $e');
    }
    isLoading(false);
  }

  var isProfileInformationLoading = false.obs;

  Future<String> uploadImageToFirebaseStorage(File image) async {
    String imageUrl = '';
    String fileName = path.basename(image.path);

    var reference =
        FirebaseStorage.instance.ref().child('profileImages/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      imageUrl = value;
    }).catchError((e) {
      Get.snackbar('Failed', 'Profile image upload failed!',
          colorText: AppColors.white, backgroundColor: AppColors.blue);
      log("Error happen $e");
    });

    return imageUrl;
  }
}
