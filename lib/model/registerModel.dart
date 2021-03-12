class registerModel {
  int code;
  String message;
  Data data;

  registerModel({this.code, this.message, this.data});

  registerModel.fromJson(Map<String, dynamic> json) {
    code = int.parse(json['code'].toString());
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
  String userName;
  int userId;
  String phoneNum;

  Data({this.userName, this.userId, this.phoneNum});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userId = json['userId'];
    phoneNum = json['phone_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['phone_num'] = this.phoneNum;
    return data;
  }
}