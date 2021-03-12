class RatingData {
  String code;
  String message;
  Data data;

  RatingData({this.code, this.message, this.data});

  RatingData.fromJson(Map<String, dynamic> json) {
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
  List<Score> score;

  Data({this.score});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['score'] != null) {
      score = new List<Score>();
      json['score'].forEach((v) {
        score.add(new Score.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.score != null) {
      data['score'] = this.score.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Score {
  int dishId;
  String dishName;
  double dishScore;

  Score({this.dishId, this.dishName, this.dishScore});

  Score.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishScore = json['dish_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['dish_name'] = this.dishName;
    data['dish_score'] = this.dishScore;
    return data;
  }
}