import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/event_participant_model.dart';
import 'package:get/get.dart';

class GroupEventModel {
  String? docId;
  String? eventId;
  String? teamName;
  String? teamLeaderUid;
  IndividualParticipantModel leaderDetail;
  List<IndividualParticipantModel> groupOfMembers;
  String? createdAt;
  RxBool? attendance;

  GroupEventModel({
    this.docId,
    required this.leaderDetail,
    required this.eventId,
    required this.teamName,
    required this.teamLeaderUid,
    required this.groupOfMembers,
    required this.createdAt,
    required this.attendance,
  });

  factory GroupEventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    List<IndividualParticipantModel> temp = [];
    for (int i = 0; i < (json['num_of_member']); i++) {
      temp.add(IndividualParticipantModel.fromJson(json['member${i + 1}']));
    }
    String? docId = snapshot.id;
    String? eventId = json['event_id'];
    String? teamName = json['team_name'];
    String? teamLeaderUid = json['team_leader_uid'];
    IndividualParticipantModel leader =
        IndividualParticipantModel.fromJson(json['leader_details']);
    List<IndividualParticipantModel> groupOfMembers = temp;
    String? createdAt = json['created_at'];
    RxBool? attendance = RxBool(json['attendance'] ?? false);
    return GroupEventModel(
      docId: docId,
      eventId: eventId,
      teamName: teamName,
      teamLeaderUid: teamLeaderUid,
      leaderDetail: leader,
      groupOfMembers: groupOfMembers,
      createdAt: createdAt,
      attendance: attendance,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    for (int i = 0; i < groupOfMembers.length; i++) {
      json['member${i + 1}'] = groupOfMembers[i].toJson();
    }
    json['event_id'] = eventId;
    json['team_name'] = teamName!.capitalizeFirst;
    json['team_leader_uid'] = teamLeaderUid;
    json['leader_details'] = leaderDetail.toJson();
    json['num_of_member'] = groupOfMembers.length;
    json['created_at'] = createdAt;
    json['attendance'] = attendance!.value;
    return json;
  }
}
