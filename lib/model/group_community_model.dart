import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'community_model.dart';

class GroupCommunityModel {
  String? id;
  String? eventId;
  String? communityName;
  int? noOfCommunity;
  List<CommunityModel>? groupOfMembers;
  String? createdAt;

  GroupCommunityModel({
    this.id,
    this.eventId,
    this.communityName,
    this.noOfCommunity,
    this.groupOfMembers,
    this.createdAt,
  });

  factory GroupCommunityModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data()!;
    List<CommunityModel> temp = [];
    for (int i = 0; i < int.parse(json['num_of_member']); i++) {
      temp.add(CommunityModel.fromJson(json['member${i + 1}']));
    }
    String? id = snapshot.id;
    String? eventId = json['event_id'];
    String? communityName = json['community_name'];
    List<CommunityModel>? groupOfMembers = temp;
    String? createdAt = json['created_at'];

    return GroupCommunityModel(
      id: id,
      eventId: eventId,
      communityName: communityName,
      groupOfMembers: groupOfMembers,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    for (int i = 0; i < groupOfMembers!.length; i++) {
      json['member${i + 1}'] = groupOfMembers![i].toJson();
    }
    json['event_id'] = eventId;
    json['community_name'] = communityName!.capitalizeFirst;
    json['num_of_member'] = groupOfMembers!.length;
    json['created_at'] = createdAt;
    return json;
  }
}
