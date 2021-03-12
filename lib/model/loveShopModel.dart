class loveShopModel{
  String code;
  String message;
  List<Data> data;

  loveShopModel({this.code, this.message, this.data});

  loveShopModel.fromJson(Map<String, dynamic> json) {
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
  int storeId;
  int canteenId;
  int areaId;
  String storeName;
  String business;
  String url;

  Data(
      {this.storeId,
        this.canteenId,
        this.areaId,
        this.storeName,
        this.business,
        this.url});

  Data.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    canteenId = json['canteen_id'];
    areaId = json['area_id'];
    storeName = json['store_name'];
    business = json['business'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['canteen_id'] = this.canteenId;
    data['area_id'] = this.areaId;
    data['store_name'] = this.storeName;
    data['business'] = this.business;
    data['url'] = this.url;
    return data;
  }
}