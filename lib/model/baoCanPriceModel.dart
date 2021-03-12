class sysConfigModel {
  String code;
  String message;
  List<PriceData> data;

  sysConfigModel({this.code, this.message, this.data});

  sysConfigModel.fromJson(Map<String, dynamic> json) {
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
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceData {
  String configKey;
  String configValue;
  int configId;
  String configDesc;
  int canteenId;

  PriceData(
      {this.configKey,
        this.configValue,
        this.configId,
        this.configDesc,
        this.canteenId});

  PriceData.fromJson(Map<String, dynamic> json) {
    configKey = json['config_key'];
    configValue = json['config_value'];
    configId = json['config_id'];
    configDesc = json['config_desc'];
    canteenId = json['canteen_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['config_key'] = this.configKey;
    data['config_value'] = this.configValue;
    data['config_id'] = this.configId;
    data['config_desc'] = this.configDesc;
    data['canteen_id'] = this.canteenId;
    return data;
  }
}

class setPriceReturnModel {
  String code;
  String message;
  Null data;

  setPriceReturnModel({this.code, this.message, this.data});

  setPriceReturnModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}