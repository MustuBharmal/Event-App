import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  final String event;
  final String eventName;
  final String? location;
  final String eventDay;
  final String rgStDate;
  final String rgEdDate;
  final String? startTime;
  final String? endTime;
  final int? maxEntries;
  final String? frequencyOfEvent;
  final String? description;
  final String? whoCanInvite;
  final List<String> joined;
  final List<dynamic> media;
  String uid;
  final List<String> tags;
  final List<String>? inviter;
  final List<String> likes;
  final List<String> saves;

  EventModel({
    this.id,
    required this.event,
    required this.eventName,
    required this.location,
    required this.eventDay,
    required this.rgStDate,
    required this.rgEdDate,
    required this.startTime,
    required this.endTime,
    required this.maxEntries,
    required this.frequencyOfEvent,
    required this.description,
    required this.whoCanInvite,
    required this.joined,
    required this.media,
    required this.uid,
    required this.tags,
    required this.inviter,
    required this.likes,
    required this.saves,
  });

  fromJson(Map<String, dynamic> json) {
    return EventModel(
      event: json['event'],
      eventName: json['event_name'],
      location: json['location'],
      eventDay: json['date'],
      rgStDate: json['startDate'],
      rgEdDate: json['endDate'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      maxEntries: json['max_entries'],
      frequencyOfEvent: json['frequency_of_event'],
      description: json['description'],
      whoCanInvite: json['who_can_invite'],
      joined: json['joined'].cast<String>(),
      media: json['media'],
      uid: json['uid'],
      tags: json['tags'].cast<String>(),
      inviter: json['inviter'].cast<String>(),
      likes: json['likes'].cast<String>(),
      saves: json['saves'].cast<String>(),
    );
  }

  factory EventModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data()!;
    return EventModel(
      id: json.id,
      event: data['event'],
      eventName: data['event_name'],
      location: data['location'],
      eventDay: data['date'],
      rgStDate: data['startDate'],
      rgEdDate: data['endDate'],
      startTime: data['start_time'],
      endTime: data['end_time'],
      maxEntries: data['max_entries'],
      frequencyOfEvent: data['frequency_of_event'],
      description: data['description'],
      whoCanInvite: data['who_can_invite'],
      joined: data['joined'].cast<String>(),
      media: data['media'],
      uid: data['uid'],
      tags: data['tags'].cast<String>(),
      inviter: data['inviter'].cast<String>(),
      likes: data['likes'].cast<String>(),
      saves: data['saves'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['event_name'] = eventName;
    data['location'] = location;
    data['date'] = eventDay;
    data['startDate'] = rgStDate;
    data['endDate'] = rgEdDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['max_entries'] = maxEntries;
    data['frequency_of_event'] = frequencyOfEvent;
    data['description'] = description;
    data['who_can_invite'] = whoCanInvite;
    data['joined'] = joined;
    data['media'] = media;
    data['uid'] = uid;
    data['tags'] = tags;
    data['inviter'] = inviter;
    data['likes'] = likes;
    data['saves'] = saves;
    return data;
  }
}
