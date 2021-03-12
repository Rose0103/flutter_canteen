class habbitModel {
  bool flag;
  int code;
  String message;
  Data data;

  habbitModel({this.flag, this.code, this.message, this.data});

  habbitModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    code = int.parse(json['code']);
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userHobby;

  Data({this.userHobby});

  Data.fromJson(Map<String, dynamic> json) {
    userHobby = json['hobby_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hobby_code'] = this.userHobby;
    return data;
  }
}