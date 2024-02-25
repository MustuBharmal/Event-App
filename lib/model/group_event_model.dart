import 'package:cloud_firestore/cloud_firestore.dart';

class GroupEventModel {
  String? leaderUid;
  List<String>? membersName;
  List<String>? membersEmail;
  List<String>? membersSem;
  List<String>? membersDept;

  GroupEventModel({
    this.leaderUid,
    this.membersName,
    this.membersEmail,
    this.membersDept,
    this.membersSem,
  });

  factory GroupEventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? leaderUid = json['leaderUid'];
    List<String>? membersName = json['membersName'];
    List<String>? membersEmail = json['membersEmail'];
    List<String>? membersSem = json['membersSem'];
    List<String>? membersDept = json['membersDept'];

    return GroupEventModel(
        leaderUid: leaderUid,
        membersName: membersName,
        membersEmail: membersEmail,
        membersSem: membersSem,
        membersDept: membersDept);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['leaderUid'] = leaderUid;
    json['membersName'] = membersName;
    json['membersEmail'] = membersEmail;
    json['membersSem'] = membersSem;
    json['membersDept'] = membersDept;
    return json;
  }
}
