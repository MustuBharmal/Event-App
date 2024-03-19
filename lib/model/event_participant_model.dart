import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class IndividualParticipantModel {
  String? docId;
  String? eventId;
  String? membersUid;
  String? membersName;
  String? membersEmail;
  String? membersSem;
  String? membersFaculty;
  String? membersDept;
  String? membersNum;
  String? createdAt;
  RxBool? attendance;

  IndividualParticipantModel({
    this.docId,
    this.eventId,
    this.membersUid,
    this.membersName,
    this.membersEmail,
    this.membersDept,
    this.membersFaculty,
    this.membersSem,
    this.membersNum,
    this.createdAt,
    this.attendance,
  });

  factory IndividualParticipantModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? docId = snapshot.id;
    String? eventId = json['event_id'];
    String? membersUid = json['members_id'];
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersSem = json['members_sem'];
    String? membersFaculty = json['members_faculty'];
    String? membersDept = json['members_dept'];
    String? membersNum = json['members_num'];
    String? createdAt = json['created_at'];
    RxBool? attendance = RxBool(json['attendance']);
    return IndividualParticipantModel(
      docId: docId,
      eventId: eventId,
      membersUid: membersUid,
      membersName: membersName,
      membersEmail: membersEmail,
      membersSem: membersSem,
      membersFaculty: membersFaculty,
      membersDept: membersDept,
      membersNum: membersNum,
      createdAt: createdAt,
      attendance: attendance,
    );
  }

  factory IndividualParticipantModel.fromJson(Map<String, dynamic> json) {
    String? eventId = json['event_id'];
    String? membersUid = json['members_uid'];
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersSem = json['members_sem'];
    String? membersFaculty = json['members_faculty'];
    String? membersDept = json['members_dept'];
    String? membersNum = json['members_num'];
    String? createdAt = json['created_at'];
    RxBool? attendance = RxBool(json['attendance'] ?? false);
    return IndividualParticipantModel(
      eventId: eventId,
      membersUid: membersUid,
      membersName: membersName,
      membersEmail: membersEmail,
      membersSem: membersSem,
      membersFaculty: membersFaculty,
      membersDept: membersDept,
      membersNum: membersNum,
      createdAt: createdAt,
      attendance: attendance,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['event_id'] = eventId;
    json['members_id'] = membersUid;
    json['members_name'] = membersName;
    json['members_email'] = membersEmail;
    json['members_sem'] = membersSem;
    json['members_faculty'] = membersFaculty;
    json['members_dept'] = membersDept!;
    json['members_num'] = membersNum;
    json['created_at'] = createdAt;
    json['attendance'] = attendance?.value;
    return json;
  }
}
