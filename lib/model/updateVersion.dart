class updateModel {
  String code;
  String message;
  Data data;

  updateModel({this.code, this.message, this.data});

  updateModel.fromJson(Map<String, dynamic> json) {
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
  String verison;
  String force;
  String androidUrl;
  String iosUrl;

  Data({this.verison, this.force, this.androidUrl, this.iosUrl});

  Data.fromJson(Map<String, dynamic> json) {
    verison = json['verison'];
    force = json['force'];
    androidUrl = json['android_url'];
    iosUrl = json['ios_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verison'] = this.verison;
    data['force'] = this.force;
    data['android_url'] = this.androidUrl;
    data['ios_url'] = this.iosUrl;
    return data;
  }
}