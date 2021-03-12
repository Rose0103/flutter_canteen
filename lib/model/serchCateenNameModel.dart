class searchcanteennameModel {
  String code;
  String message;
  List<Canteens> data;

  searchcanteennameModel({this.code, this.message, this.data});

  searchcanteennameModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Canteens>();
      json['data'].forEach((v) {
        data.add(new Canteens.fromJson(v));
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

class Canteens {
  int canteenId;
  String canteenName;
  int organizeId;
  String organizeName;

  Canteens({this.canteenId, this.canteenName, this.organizeId, this.organizeName});

  Canteens.fromJson(Map<String, dynamic> json) {
    canteenId = json['canteen_id'];
    canteenName = json['canteen_name'];
    organizeId = json['organize_id'];
    organizeName = json['organize_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canteen_id'] = this.canteenId;
    data['canteen_name'] = this.canteenName;
    data['organize_id'] = this.organizeId;
    data['organize_name'] = this.organizeName;
    return data;
  }
}