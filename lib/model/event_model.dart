import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  final String participantType;
  final String eventType;
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
  final List<String> joined;
  final List<dynamic> media;
  String uid;
  final List<String> tags;
  final List<String>? inviter;
  final List<String> likes;
  final List<String> saves;

  EventModel({
    this.id,
    required this.participantType,
    required this.eventType,
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
    required this.joined,
    required this.media,
    required this.uid,
    required this.tags,
    required this.inviter,
    required this.likes,
    required this.saves,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    String participantType = json['event'];
    String eventType = json['event_type'];
    String eventName = json['event_name'];
    String location = json['location'];
    String eventDay = json['date'];
    String rgStDate = json['startDate'];
    String rgEdDate = json['endDate'];
    String startTime = json['start_time'];
    String endTime = json['end_time'];
    int? maxEntries = json['max_entries'];
    String? frequencyOfEvent = json['frequency_of_event'];
    String? description = json['description'];
    final List<String> joined = json['joined'].cast<String>();
    final List<dynamic> media = json['media'];
    String uid = json['uid'];
    final List<String> tags = json['tags'].cast<String>();
    final List<String> inviter = json['inviter'].cast<String>();
    final List<String> likes = json['likes'].cast<String>();
    final List<String> saves = json['saves'].cast<String>();
    return EventModel(
        participantType: participantType,
        eventType: eventType,
        eventName: eventName,
        location: location,
        eventDay: eventDay,
        rgStDate: rgStDate,
        rgEdDate: rgEdDate,
        startTime: startTime,
        endTime: endTime,
        maxEntries: maxEntries,
        frequencyOfEvent: frequencyOfEvent,
        description: description,
        joined: joined,
        media: media,
        uid: uid,
        tags: tags,
        inviter: inviter,
        likes: likes,
        saves: saves);
  }

  factory EventModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data()!;
    return EventModel(
      id: json.id,
      participantType: data['event'],
      eventType: data['event_type'],
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
    data['event'] = participantType;
    data['event_type'] = eventType;
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
