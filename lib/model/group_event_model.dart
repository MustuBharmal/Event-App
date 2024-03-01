import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_member_model.dart';

class GroupEventModel {
  String? eventId;
  String? teamName;
  String? teamLeaderUid;
  GroupMemberModel leaderDetail;
  List<GroupMemberModel> groupOfMembers;

  GroupEventModel(
      {required this.leaderDetail,
      required this.eventId,
      required this.teamName,
      required this.teamLeaderUid,
      required this.groupOfMembers});

  factory GroupEventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    List<GroupMemberModel> temp = [];
    for (int i = 0; i < int.parse(json['num_of_member']); i++) {
      temp.add(GroupMemberModel.fromJson(json['member${i + 1}']));
    }
    String? eventId = json['event_id'];
    String? teamName = json['team_name'];
    String? teamLeaderUid = json['team_leader_uid'];
    GroupMemberModel leader = GroupMemberModel.fromJson(json['leader_details']);
    List<GroupMemberModel> groupOfMembers = temp;

    return GroupEventModel(
      eventId: eventId,
      teamName: teamName,
      teamLeaderUid: teamLeaderUid,
      leaderDetail: leader,
      groupOfMembers: groupOfMembers,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    for (int i = 0; i < groupOfMembers.length; i++) {
      json['member${i + 1}'] = groupOfMembers[i].toJson();
    }
    json['event_id'] = eventId;
    json['team_name'] = teamName;
    json['team_leader_uid'] = teamLeaderUid;
    json['leader_details'] = leaderDetail.toJson();
    json['num_of_member'] = groupOfMembers.length;
    return json;
  }
}
