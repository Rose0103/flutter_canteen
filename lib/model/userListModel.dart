//modify by
class userListModel {
  String code;
  String message;
  List<Data> data;

  userListModel({this.code, this.message, this.data});

  userListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int userId;
  String userName;
  String phoneNum;
  String money;
  int level;
  int rootOrganizeId;
  int organizeId;
  String rootOrganizeName;
  String organizeName;
  int ticket_num;
  bool sex;
  bool isEnabled;
  bool isEmployee;


  Data(
     {this.userId,
      this.userName,
      this.phoneNum,
      this.money,
      this.level,
      this.rootOrganizeId,
      this.organizeId,
      this.rootOrganizeName,
      this.organizeName,
      this.ticket_num,
       this.isEmployee
     }
      );

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    phoneNum = json['phone_num'];
    money = json['money'];
    level = json['level'];
    rootOrganizeId = json['root_organize_id'];
    organizeId = json['organize_id'];
    rootOrganizeName = json['root_organize_name'];
    organizeName = json['organize_name'];
    ticket_num = json['ticket_num'];
    sex = json['sex'];
    isEnabled = json['is_enabled'];
    isEmployee = json['is_employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['phone_num'] = this.phoneNum;
    data['money'] = this.money;
    data['level'] = this.level;
    data['root_organize_id'] = this.rootOrganizeId;
    data['organize_id'] = this.organizeId;
    data['root_organize_name'] = this.rootOrganizeName;
    data['organize_name'] = this.organizeName;
    data['ticket_num'] = this.ticket_num;
    data['sex'] = this.sex;
    data['is_enabled'] = this.isEnabled;
    data['is_employee'] = this.isEmployee;
    return data;
  }
}
