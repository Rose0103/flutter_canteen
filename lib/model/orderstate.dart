class orderStateModelData {
  String code;
  String message;
  List<Data> data;

  orderStateModelData({this.code, this.message, this.data});

  orderStateModelData.fromJson(Map<String, dynamic> json) {
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
  int mealstatId;
  int userId;
  String orderDate;
  int mealType;
  int quantity;
  int state;
  double price;
  int diningStatus;
  List<OrderList> orderList;
  int canteenid;

  Data(
      {this.mealstatId,
        this.userId,
        this.orderDate,
        this.mealType,
        this.quantity,
        this.state,
        this.price,
        this.diningStatus,
        this.orderList,
        this.canteenid});

  Data.fromJson(Map<String, dynamic> json) {
    mealstatId = json['mealstat_id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    mealType = json['meal_type'];
    quantity = json['quantity'];
    state = json['state'];
    if(json['price']!=null)
    price = double.parse(json['price'].toString());
    else price=0.0;
    diningStatus = json['dining_status'];
    if (json['order_list'] != null) {
      orderList = new List<OrderList>();
      json['order_list'].forEach((v) {
        orderList.add(new OrderList.fromJson(v));
      });
    }
    canteenid = json['canteen_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mealstat_id'] = this.mealstatId;
    data['user_id'] = this.userId;
    data['order_date'] = this.orderDate;
    data['meal_type'] = this.mealType;
    data['quantity'] = this.quantity;
    data['state'] = this.state;
    data['price'] = this.price;
    data['dining_status'] = this.diningStatus;
    if (this.orderList != null) {
      data['order_list'] = this.orderList.map((v) => v.toJson()).toList();
    }
    data['canteen_id'] = this.canteenid;
    return data;
  }
}

class OrderList {
  int orderId;
  int amount;
  double price;
  int mealstatIdId;
  int dishId;

  OrderList(
      {this.orderId, this.amount, this.price, this.mealstatIdId, this.dishId});

  OrderList.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    amount = json['amount'];
    price = json['price'];
    mealstatIdId = json['mealstat_id_id'];
    dishId = json['dish_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['mealstat_id_id'] = this.mealstatIdId;
    data['dish_id'] = this.dishId;
    return data;
  }
}



class OrderStateBackData {
  String code;
  String message;
  Datameal data;

  OrderStateBackData({this.code, this.message, this.data});

  OrderStateBackData.fromJson(Map<String, dynamic> json) {
    code = json['code'].toString();
    message = json['message'];
    data = json['data'] != null ? new Datameal.fromJson(json['data']) : null;
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

class Datameal {
  int mealstatId;
  int diningStatus;

  Datameal({this.mealstatId, this.diningStatus});

  Datameal.fromJson(Map<String, dynamic> json) {
    mealstatId = json['mealstat_id'];
    diningStatus = json['dining_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mealstat_id'] = this.mealstatId;
    data['dining_status'] = this.diningStatus;
    return data;
  }
}

