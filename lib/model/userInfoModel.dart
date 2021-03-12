class userInfoModel {
  String code;
  String message;
  Data data;

  userInfoModel({this.code, this.message, this.data});

  userInfoModel.fromJson(Map<String, dynamic> json) {
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
  String userName;
  String birthday;
  String phoneNum;
  int canteenId;
  int age;
  String userType;
  bool isEmployee;
  int sex;
  String portraitNew;
  String money;
  int ticket_num;
  String canteenName;
  int organizeId;
  int rootOrgId;
  String organizeName;
  String feature;

  Data(
      {this.userName,
        this.birthday,
        this.phoneNum,
        this.canteenId,
        this.age,
        this.userType,
        this.isEmployee,
        this.sex,
        this.portraitNew,
        this.money,
        this.ticket_num,
        this.canteenName,
        this.organizeId,
        this.rootOrgId,
        this.organizeName,
        this.feature});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    birthday = json['birthday'];
    phoneNum = json['phone_num'];
    canteenId = json['canteen_id'];
    age = json['age'];
    userType = json['user_type'];
    isEmployee = json['is_employee'];
    if(json.containsKey('sex')&&json['sex']!=null) {
      bool sexbool=json['sex'];
      if(sexbool)
        sex = 1;
      else sex=2;
    }
    portraitNew = json['portrait_new'];
    money = json['money'];
    ticket_num = json['ticket_num'];
    canteenName = json['canteen_name'];
    organizeId = json['organize_id'];
    rootOrgId = json['root_organize_id'];
    organizeName = json['organize_name'];
    feature = json['feature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['birthday'] = this.birthday;
    data['phone_num'] = this.phoneNum;
    data['canteen_id'] = this.canteenId;
    data['age'] = this.age;
    data['user_type'] = this.userType;
    data['is_employee'] = this.isEmployee;
    data['sex'] = this.sex;
    data['portrait_new'] = this.portraitNew;
    data['money'] = this.money;
    data['ticket_num'] = this.ticket_num;
    data['canteen_name'] = this.canteenName;
    data['organize_id'] = this.organizeId;
    data['root_organize_id'] = this.rootOrgId;
    data['organize_name'] = this.organizeName;
    data['feature'] = this.feature;
    return data;
  }
}