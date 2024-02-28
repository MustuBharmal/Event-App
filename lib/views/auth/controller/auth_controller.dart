import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/views/auth/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../model/user_model.dart';
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
    // TODO: implement dispose
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
      user.value = null;
    } catch (e) {
      Get.snackbar('Error', '$e');
    }
    isLogoutLoading(false);
  }

  checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (FirebaseAuth.instance.currentUser == null) {
      Get.offNamed(LoginView.routeName);
    } else {
      print("hello in check login");
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
    } catch (e) {
      print('$e');
    }
    isLoading(false);
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

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      log("Error in sending password reset email is $e");
    });
  }

  signInWithGoogle() async {
    isLoading(true);
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      isLoading(false);

      ///SuccessFull logged in
      Get.to(() => const BottomBarView());
    }).catchError((e) {
      /// Error in getting Login
      isLoading(false);
      log("Error is $e");
    });
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
      log("Error happen $e");
    });

    return imageUrl;
  }
}
