///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class foodscoreModelDataScore {
/*
{
  "dish_id": 1,
  "dish_name": "辣椒炒肉",
  "dish_score": 4
}
*/

  int dishId;
  String dishName;
  int dishScore;

  foodscoreModelDataScore({
    this.dishId,
    this.dishName,
    this.dishScore,
  });
  foodscoreModelDataScore.fromJson(Map<String, dynamic> json) {
    dishId = json["dish_id"]?.toInt();
    dishName = json["dish_name"]?.toString();
    dishScore = json["dish_score"]?.toInt();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["dish_id"] = dishId;
    data["dish_name"] = dishName;
    data["dish_score"] = dishScore;
    return data;
  }
}

class foodscoreModelData {
/*
{
  "score": [
    {
      "dish_id": 1,
      "dish_name": "辣椒炒肉",
      "dish_score": 4
    }
  ]
}
*/

  List<foodscoreModelDataScore> score;

  foodscoreModelData({
    this.score,
  });
  foodscoreModelData.fromJson(Map<String, dynamic> json) {
    if (json["score"] != null) {
      var v = json["score"];
      var arr0 = List<foodscoreModelDataScore>();
      v.forEach((v) {
        arr0.add(foodscoreModelDataScore.fromJson(v));
      });
      score = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (score != null) {
      var v = score;
      var arr0 = List();
      v.forEach((v) {
        arr0.add(v.toJson());
      });
      data["score"] = arr0;
    }
    return data;
  }
}

class foodscoreModel {
/*
{
  "code": "0",
  "message": "success",
  "data": {
    "score": [
      {
        "dish_id": 1,
        "dish_name": "辣椒炒肉",
        "dish_score": 4
      }
    ]
  }
}
*/

  String code;
  String message;
  foodscoreModelData data;

  foodscoreModel({
    this.code,
    this.message,
    this.data,
  });
  foodscoreModel.fromJson(Map<String, dynamic> json) {
    code = json["code"]?.toString();
    message = json["message"]?.toString();
    data = json["data"] != null ? foodscoreModelData.fromJson(json["data"]) : null;
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