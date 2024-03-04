import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserModel {
  String? uid;
  String? image;
  String? first;
  String? last;
  String? dob;
  String? gender;
  String? userType;
  String? mobileNumber;
  String? email;
  List<dynamic>? joinedEvents;
  List<dynamic>? organizedEvents;

  UserModel(
      {this.uid,
      this.image,
      this.first,
      this.last,
      this.dob,
      this.gender,
      this.userType,
      this.mobileNumber,
      this.email,
      this.joinedEvents,
      this.organizedEvents});

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final json = data.data()!;
    String uid = json['uid'] ?? "";
    String image = json['image'] ?? '';
    String first = json['first'] ?? '';
    String last = json['last'] ?? '';
    String dob = json['dob'] ?? '';
    String gender = json['gender'] ?? '';
    String userType = json['user_type'] ?? '';
    String mobileNumber = json['mobileNumber'] ?? '';
    String email = json['email'] ?? '';
    List<dynamic> joinedEvents = json['joinedEvents'] ?? [];
    List<dynamic> organizedEvents = json['organizedEvents'] ?? [];
    return UserModel(
        uid: uid,
        image: image,
        first: first,
        last: last,
        dob: dob,
        gender: gender,
        userType: userType,
        mobileNumber: mobileNumber,
        email: email,
        joinedEvents: joinedEvents,
        organizedEvents: organizedEvents);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? uid = json['uid'];
    String? image = json['image'];
    String? first = json['first'];
    String? last = json['last'];
    String? dob = json['dob'];
    String? gender = json['gender'];
    String? userType = json['user_type'];
    String? mobileNumber = json['mobileNumber'];
    String? email = json['email'];
    List<String> joinedEvents = json['joinedEvents'];
    List<String> organizedEvents = json['organizedEvents'];
    return UserModel(
        uid: uid,
        image: image,
        first: first,
        last: last,
        dob: dob,
        gender: gender,
        userType: userType,
        mobileNumber: mobileNumber,
        email: email,
        joinedEvents: joinedEvents,
        organizedEvents: organizedEvents);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['image'] = image;
    data['first'] = first!.capitalizeFirst;
    data['last'] = last!.capitalizeFirst;
    data['dob'] = dob;
    data['gender'] = gender;
    data['user_type'] = userType;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['joinedEvents'] = joinedEvents;
    data['organizedEvents'] = organizedEvents;
    return data;
  }
}
