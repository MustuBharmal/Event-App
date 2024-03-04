import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/event_participant_model.dart';
import 'package:get/get.dart';

class GroupEventModel {
  String? eventId;
  String? teamName;
  String? teamLeaderUid;
  EventParticipantModel leaderDetail;
  List<EventParticipantModel> groupOfMembers;
  String? createdAt;

  GroupEventModel({
    required this.leaderDetail,
    required this.eventId,
    required this.teamName,
    required this.teamLeaderUid,
    required this.groupOfMembers,
    required this.createdAt,
  });

  factory GroupEventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    List<EventParticipantModel> temp = [];
    for (int i = 0; i < int.parse(json['num_of_member']); i++) {
      temp.add(EventParticipantModel.fromJson(json['member${i + 1}']));
    }
    String? eventId = json['event_id'];
    String? teamName = json['team_name'];
    String? teamLeaderUid = json['team_leader_uid'];
    EventParticipantModel leader =
        EventParticipantModel.fromJson(json['leader_details']);
    List<EventParticipantModel> groupOfMembers = temp;
    String? createdAt = json['created_at'];

    return GroupEventModel(
      eventId: eventId,
      teamName: teamName,
      teamLeaderUid: teamLeaderUid,
      leaderDetail: leader,
      groupOfMembers: groupOfMembers,
      createdAt: createdAt,
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
    return json;
  }
}
