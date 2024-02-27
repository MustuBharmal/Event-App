import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMemberModel {
  String? membersName;
  String? membersEmail;
  String? membersSem;
  String? membersDept;
  String? membersNum;

  GroupMemberModel({
    this.membersName,
    this.membersEmail,
    this.membersDept,
    this.membersSem,
    this.membersNum,
  });

  factory GroupMemberModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? membersName = json['members_name'].cast<String>();
    String? membersEmail = json['members_email'].cast<String>();
    String? membersSem = json['members_sem'].cast<String>();
    String? membersDept = json['members_dept'].cast<String>();
    String? membersNum = json['members_num'].cast<String>();
    return GroupMemberModel(
      membersName: membersName,
      membersEmail: membersEmail,
      membersSem: membersSem,
      membersDept: membersDept,
      membersNum: membersNum,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['members_name'] = membersName;
    json['members_email'] = membersEmail;
    json['members_sem'] = membersSem;
    json['members_dept'] = membersDept;
    json['members_num'] = membersNum;
    return json;
  }
}
