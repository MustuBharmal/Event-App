import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EventParticipantModel {
  String? eventId;
  String? membersName;
  String? membersEmail;
  String? membersSem;
  String? membersDept;
  String? membersNum;
  String? createdAt;

  EventParticipantModel({
    this.eventId,
    this.membersName,
    this.membersEmail,
    this.membersDept,
    this.membersSem,
    this.membersNum,
    this.createdAt,
  });

  factory EventParticipantModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? eventId = json['event_id'];
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersSem = json['members_sem'];
    String? membersDept = json['members_dept'];
    String? membersNum = json['members_num'];
    String? createdAt = json['created_at'];
    return EventParticipantModel(
      eventId: eventId,
      membersName: membersName,
      membersEmail: membersEmail,
      membersSem: membersSem,
      membersDept: membersDept,
      membersNum: membersNum,
      createdAt: createdAt,
    );
  }

  factory EventParticipantModel.fromJson(Map<String, dynamic> json) {
    String? eventId = json['event_id'];
    String? membersName = json['members_name'];
    String? membersEmail = json['members_email'];
    String? membersSem = json['members_sem'];
    String? membersDept = json['members_dept'];
    String? membersNum = json['members_num'];
    String? createdAt = json['created_at'];
    return EventParticipantModel(
      eventId: eventId,
      membersName: membersName,
      membersEmail: membersEmail,
      membersSem: membersSem,
      membersDept: membersDept,
      membersNum: membersNum,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['event_id'] = eventId;
    json['members_name'] = membersName!.capitalizeFirst;
    json['members_email'] = membersEmail;
    json['members_sem'] = membersSem;
    json['members_dept'] = membersDept!.toLowerCase();
    json['members_num'] = membersNum;
    json['created_at'] = createdAt;
    return json;
  }
}
