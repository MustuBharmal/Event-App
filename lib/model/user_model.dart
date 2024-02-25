class UserModel {
  String? uid;
  String? image;
  String? first;
  String? last;
  String? dob;
  String? gender;
  String? userType;
  String? mobileNumber;
  String? email;
  List<String>? joinedEvents;
  List<String>? organizedEvents;

  UserModel(
      {required this.uid,
      required this.image,
      required this.first,
      required this.last,
      required this.dob,
      required this.gender,
      required this.userType,
      required this.mobileNumber,
      required this.email,
      required this.joinedEvents,
      required this.organizedEvents});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? uid = json['uid'];
    String? image = json['image'];
    String? first = json['first'];
    String? last = json['last'];
    String? dob = json['dob'];
    String? gender = json['gender'];
    String? userType = json['user_type'];
    String? mobileNumber = json['mobileNumber'];
    String? email = json['email'];
    List<String> joinedEvents = json['joinedEvents'];
    List<String> organizedEvents = json['organizedEvents'];
    return UserModel(
        uid: uid,
        image: image,
        first: first,
        last: last,
        dob: dob,
        gender: gender,
        userType: userType,
        mobileNumber: mobileNumber,
        email: email,
        joinedEvents: joinedEvents,
        organizedEvents: organizedEvents);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['image'] = image;
    data['first'] = first;
    data['last'] = last;
    data['dob'] = dob;
    data['gender'] = gender;
    data['user_type'] = userType;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['joinedEvents'] = joinedEvents;
    data['organizedEvents'] = organizedEvents;
    return data;
  }
}
