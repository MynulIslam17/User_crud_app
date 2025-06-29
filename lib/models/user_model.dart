class UserModel {
  String? userName;
  String? email;
  String? avatar;
  Profile? profile;
  List<String>? language;
  String? id;

  UserModel(
      {this.userName,
        this.email,
        this.avatar,
        this.profile,
        this.language,
        this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    avatar = json['avatar'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    language = json['language'].cast<String>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['language'] = this.language;
    data['id'] = this.id;
    return data;
  }
}

class Profile {
  String? first;
  String? last;
  int? age;
  String? gender;

  Profile({this.first, this.last, this.age, this.gender});

  Profile.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    age = json['age'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['age'] = this.age;
    data['gender'] = this.gender;
    return data;
  }
}