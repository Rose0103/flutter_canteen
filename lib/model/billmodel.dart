class billmodel {
  String code;
  String message;
  List<Data> data;

  billmodel({this.code, this.message, this.data});

  billmodel.fromJson(Map<String, dynamic> json) {
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
  int billId;
  int consumerId;
  int operatorId;
  int mealstatId;
  String billPrice;
  int billType;
  String createTime;
  String updateTime;
  int mealType;
  String orderDate;

  Data(
      {this.billId,
        this.consumerId,
        this.operatorId,
        this.mealstatId,
        this.billPrice,
        this.billType,
        this.createTime,
        this.updateTime,
        this.mealType,
        this.orderDate});

  Data.fromJson(Map<String, dynamic> json) {
    billId = json['bill_id'];
    consumerId = json['consumer_id'];
    operatorId = json['operator_id'];
    mealstatId = json['mealstat_id'];
    billPrice = json['bill_price'];
    billType = json['bill_type'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    mealType = json['meal_type'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_id'] = this.billId;
    data['consumer_id'] = this.consumerId;
    data['operator_id'] = this.operatorId;
    data['mealstat_id'] = this.mealstatId;
    data['bill_price'] = this.billPrice;
    data['bill_type'] = this.billType;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['meal_type'] = this.mealType;
    data['order_date'] = this.orderDate;
    return data;
  }
}