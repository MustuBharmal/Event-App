import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/model/group_member_model.dart';

class GroupEventModel {
  String? teamName;
  String? teamLeaderUid;
  List<GroupMemberModel> groupOfMembers;

  GroupEventModel(
      {required this.teamName,
      required this.teamLeaderUid,
      required this.groupOfMembers});

  factory GroupEventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    String? teamName = json['team_name'];
    String? teamLeaderUid = json['team_leader_uid'];
    List<GroupMemberModel> groupOfMembers = json['team_mem'] ?? [];

    return GroupEventModel(
      teamName: teamName,
      teamLeaderUid: teamLeaderUid,
      groupOfMembers: groupOfMembers,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    for (int i = 0; i < groupOfMembers.length; i++) {
      json['member${i + 1}'] = groupOfMembers[i].toJson();
    }
    json['team_name'] = teamName;
    json['team_leader_uid'] = teamLeaderUid;
    return json;
  }
}
