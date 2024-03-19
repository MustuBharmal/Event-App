import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  String? membersName;
  String? membersEmail;
  String? membersNum;

  CommunityModel({
    this.membersName,
    this.membersEmail,
    this.membersNum,
  });

  factory CommunityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersNum = json['members_num'];

    return CommunityModel(
      membersName: membersName,
      membersEmail: membersEmail,
      membersNum: membersNum,
    );
  }

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersNum = json['members_num'];
    return CommunityModel(
      membersName: membersName,
      membersEmail: membersEmail,
      membersNum: membersNum,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['members_name'] = membersName;
    json['members_email'] = membersEmail;
    json['members_num'] = membersNum;
    return json;
  }
}
