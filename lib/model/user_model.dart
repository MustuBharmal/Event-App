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

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    image = json['image'];
    first = json['first'];
    last = json['last'];
    dob = json['dob'];
    gender = json['gender'];
    userType = json['user_type'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    joinedEvents = json['joinedEvents'];
    organizedEvents = json['organizedEvents'];
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
