///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class MenuDataDataMenuInfo {
/*
{
  "dish_id": 1,
  "canteen_id": 1,
  "dish_name": "辣椒炒肉",
  "dish_desc": "湖南特色菜",
  "dish_flavor": "辣",
  "dish_price": 19.9,
  "dish_photo": [
    "/dish/image1.jpg"
  ],
  "create_time": 1572509281,
  "update_time": 1573701800,
  "dish_score": 0,
  "menu_id": 12,
  "menu_date": "2019-11-15",
  "menu_type": 2,
  "category": 1
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
  int menuId;
  String menuDate;
  int menuType;
  int category;
  int num = 0;

  MenuDataDataMenuInfo({
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
    this.menuId,
    this.menuDate,
    this.menuType,
    this.category,
  });

  MenuDataDataMenuInfo.fromJson(Map<String, dynamic> json) {
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
    menuId = json["menu_id"]?.toInt();
    menuDate = json["menu_date"]?.toString();
    menuType = json["menu_type"]?.toInt();
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
    data["menu_id"] = menuId;
    data["menu_date"] = menuDate;
    data["menu_type"] = menuType;
    data["category"] = category;
    return data;
  }
}

class MenuDataData {
/*
{
  "menuInfo": [
    {
      "dish_id": 1,
      "canteen_id": 1,
      "dish_name": "辣椒炒肉",
      "dish_desc": "湖南特色菜",
      "dish_flavor": "辣",
      "dish_price": 19.9,
      "dish_photo": [
        "/dish/image1.jpg"
      ],
      "create_time": 1572509281,
      "update_time": 1573701800,
      "dish_score": 0,
      "menu_id": 12,
      "menu_date": "2019-11-15",
      "menu_type": 2,
      "category": 1
    }
  ]
} 
*/

  List<MenuDataDataMenuInfo> menuInfo;

  MenuDataData({
    this.menuInfo,
  });

  MenuDataData.fromJson(Map<String, dynamic> json) {
    if (json["menuInfo"] != null) {
      var v = json["menuInfo"];
      var arr0 = List<MenuDataDataMenuInfo>();
      v.forEach((v) {
        arr0.add(MenuDataDataMenuInfo.fromJson(v));
      });
      menuInfo = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (menuInfo != null) {
      var v = menuInfo;
      var arr0 = List();
      v.forEach((v) {
        arr0.add(v.toJson());
      });
      data["menuInfo"] = arr0;
    }
    return data;
  }
}

class MenuData {
/*
{
  "code": "0",
  "message": "success",
  "data": {
    "menuInfo": [
      {
        "dish_id": 1,
        "canteen_id": 1,
        "dish_name": "辣椒炒肉",
        "dish_desc": "湖南特色菜",
        "dish_flavor": "辣",
        "dish_price": 19.9,
        "dish_photo": [
          "/dish/image1.jpg"
        ],
        "create_time": 1572509281,
        "update_time": 1573701800,
        "dish_score": 0,
        "menu_id": 12,
        "menu_date": "2019-11-15",
        "menu_type": 2,
        "category": 1
      }
    ]
  }
} 
*/

  String code;
  String message;
  MenuDataData data;

  MenuData({
    this.code,
    this.message,
    this.data,
  });

  MenuData.fromJson(Map<String, dynamic> json) {
    code = json["code"]?.toString();
    message = json["message"]?.toString();
    data = json["data"] != null ? MenuDataData.fromJson(json["data"]) : null;
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