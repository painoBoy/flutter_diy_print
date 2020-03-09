class LoginModel {
  int code;
  LoginData data;
  String msg;
  int time;

  LoginModel({this.code, this.data, this.msg, this.time});

  LoginModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
    msg = json['msg'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    data['time'] = this.time;
    return data;
  }
}

class LoginData {
  String account;
  int age;
  String authCode;
  bool authSwitch;
  String birth;
  bool existsPwd;
  bool eyecare;
  int eyecareTime;
  String icon;
  String identityType;
  int loginType;
  String name;
  String phoneNum;
  int point;
  bool sex;
  String userId;
  String userType;

  LoginData(
      {this.account,
      this.age,
      this.authCode,
      this.authSwitch,
      this.birth,
      this.existsPwd,
      this.eyecare,
      this.eyecareTime,
      this.icon,
      this.identityType,
      this.loginType,
      this.name,
      this.phoneNum,
      this.point,
      this.sex,
      this.userId,
      this.userType});

  LoginData.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    age = json['age'];
    authCode = json['authCode'];
    authSwitch = json['authSwitch'];
    birth = json['birth'];
    existsPwd = json['existsPwd'];
    eyecare = json['eyecare'];
    eyecareTime = json['eyecareTime'];
    icon = json['icon'];
    identityType = json['identityType'];
    loginType = json['loginType'];
    name = json['name'];
    phoneNum = json['phoneNum'];
    point = json['point'];
    sex = json['sex'];
    userId = json['userId'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['age'] = this.age;
    data['authCode'] = this.authCode;
    data['authSwitch'] = this.authSwitch;
    data['birth'] = this.birth;
    data['existsPwd'] = this.existsPwd;
    data['eyecare'] = this.eyecare;
    data['eyecareTime'] = this.eyecareTime;
    data['icon'] = this.icon;
    data['identityType'] = this.identityType;
    data['loginType'] = this.loginType;
    data['name'] = this.name;
    data['phoneNum'] = this.phoneNum;
    data['point'] = this.point;
    data['sex'] = this.sex;
    data['userId'] = this.userId;
    data['userType'] = this.userType;
    return data;
  }
}
