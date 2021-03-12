class canteenModel {
  String code;
  String message;
  List<Data> data;

  canteenModel({this.code, this.message, this.data});

  canteenModel.fromJson(Map<String, dynamic> json) {
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
  int canteenId;
  String canteenName;

  Data({this.canteenId, this.canteenName});

  Data.fromJson(Map<String, dynamic> json) {
    canteenId = json['canteen_id'];
    canteenName = json['canteen_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canteen_id'] = this.canteenId;
    data['canteen_name'] = this.canteenName;
    return data;
  }
}
