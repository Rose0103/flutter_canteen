class personalSummaryDataModel {
  String code;
  String message;
  List<Data> data;

  personalSummaryDataModel({this.code, this.message, this.data});

  personalSummaryDataModel.fromJson(Map<String, dynamic> json) {
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
  int mealType;
  int price;
  int diningStatus;
  int state;
  int quantity;
  int mealstatId;
  String orderDate;

  Data(
      {this.userId,
        this.mealType,
        this.price,
        this.diningStatus,
        this.state,
        this.quantity,
        this.mealstatId,
        this.orderDate});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    mealType = json['meal_type'];
    price = json['price'];
    diningStatus = json['dining_status'];
    state = json['state'];
    quantity = json['quantity'];
    mealstatId = json['mealstat_id'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['meal_type'] = this.mealType;
    data['price'] = this.price;
    data['dining_status'] = this.diningStatus;
    data['state'] = this.state;
    data['quantity'] = this.quantity;
    data['mealstat_id'] = this.mealstatId;
    data['order_date'] = this.orderDate;
    return data;
  }
}