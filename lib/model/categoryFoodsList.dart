///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CategoryFoodsListModelDataFoodInfoList {
/*
{
  "dish_id": 3,
  "canteen_id": 1,
  "dish_name": "清炒丝瓜",
  "dish_desc": "湖南特色菜",
  "dish_flavor": "清淡",
  "dish_price": 20,
  "dish_photo": [
    "/dish/image3.jpg"
  ],
  "create_time": 1572510046,
  "update_time": 1573701800,
  "dish_score": 0,
  "category": 6
}
*/

  int dishId;
  int canteenId;
  String dishName;
  String dishDesc;
  String dishFlavor;
  double dishPrice;
  List<String> dishPhoto;
  String createTime;
  String updateTime;
  double dishScore;
  int category;
  int dingnumber=0;

  CategoryFoodsListModelDataFoodInfoList({
    this.dishId,
    this.canteenId,
    this.dishName,
    this.dishDesc,
    this.dishFlavor,
    this.dishPrice,
    this.dishPhoto,
    this.createTime,
    this.updateTime,
    this.dishScore,
    this.category,
    this.dingnumber
  });
  CategoryFoodsListModelDataFoodInfoList.fromJson(Map<String, dynamic> json) {
    dishId = json["dish_id"]?.toInt();
    canteenId = json["canteen_id"]?.toInt();
    dishName = json["dish_name"]?.toString();
    dishDesc = json["dish_desc"]?.toString();
    dishFlavor = json["dish_flavor"]?.toString();
    dishPrice = json["dish_price"]?.toDouble();
    if (json["dish_photo"] != null) {
      var v = json["dish_photo"];
      var arr0 = List<String>();
      v.forEach((v) {
        arr0.add(v.toString());
      });
      dishPhoto = arr0;
    }
    createTime = json["create_time"];
    updateTime = json["update_time"];
    dishScore = json["dish_score"]?.toDouble();
    category = json["category"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["dish_id"] = dishId;
    data["canteen_id"] = canteenId;
    data["dish_name"] = dishName;
    data["dish_desc"] = dishDesc;
    data["dish_flavor"] = dishFlavor;
    data["dish_price"] = dishPrice;
    if (dishPhoto != null) {
      var v = dishPhoto;
      var arr0 = List();
      v.forEach((v) {
        arr0.add(v);
      });
      data["dish_photo"] = arr0;
    }
    data["create_time"] = createTime;
    data["update_time"] = updateTime;
    data["dish_score"] = dishScore;
    data["category"] = category;
    return data;
  }
}

class CategoryFoodsListModelData {
/*
{
  "foodInfoList": [
    {
      "dish_id": 3,
      "canteen_id": 1,
      "dish_name": "清炒丝瓜",
      "dish_desc": "湖南特色菜",
      "dish_flavor": "清淡",
      "dish_price": 20,
      "dish_photo": [
        "/dish/image3.jpg"
      ],
      "create_time": 1572510046,
      "update_time": 1573701800,
      "dish_score": 0,
      "category": 6
    }
  ]
}
*/

  List<CategoryFoodsListModelDataFoodInfoList> foodInfoList;

  CategoryFoodsListModelData({
    this.foodInfoList,
  });
  CategoryFoodsListModelData.fromJson(Map<String, dynamic> json) {
    if (json["foodInfoList"] != null) {
      var v = json["foodInfoList"];
      var arr0 = List<CategoryFoodsListModelDataFoodInfoList>();
      v.forEach((v) {
        arr0.add(CategoryFoodsListModelDataFoodInfoList.fromJson(v));
      });
      foodInfoList = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (foodInfoList != null) {
      var v = foodInfoList;
      var arr0 = List();
      v.forEach((v) {
        arr0.add(v.toJson());
      });
      data["foodInfoList"] = arr0;
    }
    return data;
  }
}

class CategoryFoodsListModel {
/*
{
  "code": "0",
  "message": "success",
  "data": {
    "foodInfoList": [
      {
        "dish_id": 3,
        "canteen_id": 1,
        "dish_name": "清炒丝瓜",
        "dish_desc": "湖南特色菜",
        "dish_flavor": "清淡",
        "dish_price": 20,
        "dish_photo": [
          "/dish/image3.jpg"
        ],
        "create_time": 1572510046,
        "update_time": 1573701800,
        "dish_score": 0,
        "category": 6
      }
    ]
  }
}
*/

  String code;
  String message;
  CategoryFoodsListModelData data;

  CategoryFoodsListModel({
    this.code,
    this.message,
    this.data,
  });
  CategoryFoodsListModel.fromJson(Map<String, dynamic> json) {
    code = json["code"]?.toString();
    message = json["message"]?.toString();
    data = json["data"] != null ? CategoryFoodsListModelData.fromJson(json["data"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["code"] = code;
    data["message"] = message;
    if (data != null) {
      data["data"] = this.data.toJson();
    }
    return data;
  }
}

