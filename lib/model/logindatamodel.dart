class loginDataModel {
  String code;
  String message;
  Data data;

  loginDataModel({this.code, this.message, this.data});

  loginDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int userId;
  String userName;
  String userType;
  String phoneNum;
  int canteenId;
  String canteenName;
  int exp;

  Data(
      {this.userId,
        this.userName,
        this.userType,
        this.phoneNum,
        this.canteenId,
        this.canteenName,
        this.exp});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userType = json['user_type'];
    phoneNum = json['phone_num'];
    canteenId = json['canteen_id'];
    canteenName = json['canteen_name'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_type'] = this.userType;
    data['phone_num'] = this.phoneNum;
    data['canteen_id'] = this.canteenId;
    data['canteen_name'] = this.canteenName;
    data['exp'] = this.exp;
    return data;
  }
}