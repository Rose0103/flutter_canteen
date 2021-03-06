//modify by
class Autogenerated {
  String code;
  String message;
  List<AutogeneratedData> data;

  Autogenerated({this.code, this.message, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AutogeneratedData>();
      json['data'].forEach((v) {
        data.add(new AutogeneratedData.fromJson(v));
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

class AutogeneratedData {
  int organizeId;
  String organizeName;

  AutogeneratedData({this.organizeId, this.organizeName});

  AutogeneratedData.fromJson(Map<String, dynamic> json) {
    organizeId = json['organize_id'];
    organizeName = json['organize_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organize_id'] = this.organizeId;
    data['organize_name'] = this.organizeName;
    return data;
  }
}
