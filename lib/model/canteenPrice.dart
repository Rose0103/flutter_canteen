class canteenPriceModel {
  bool flag;
  int code;
  String message;
  List<PriceData> data;

  canteenPriceModel({this.flag, this.code, this.message, this.data});

  canteenPriceModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<PriceData>();
      json['data'].forEach((v) {
        data.add(new PriceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceData {
  int canteenId;
  int staffPrice;
  int visitorPrice;
  String createTime;
  String updateTime;

  PriceData(
      {this.canteenId,
        this.staffPrice,
        this.visitorPrice,
        this.createTime,
        this.updateTime});

  PriceData.fromJson(Map<String, dynamic> json) {
    canteenId = json['canteenId'];
    staffPrice = json['staffPrice'];
    visitorPrice = json['visitorPrice'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canteenId'] = this.canteenId;
    data['staffPrice'] = this.staffPrice;
    data['visitorPrice'] = this.visitorPrice;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}