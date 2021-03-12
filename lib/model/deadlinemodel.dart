class GetdeadlineModel {
  String code;
  String message;
  GetDeadLineData data;

  GetdeadlineModel({this.code, this.message, this.data});

  GetdeadlineModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new GetDeadLineData.fromJson(json['data']) : null;
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

class GetDeadLineData {
  String breakfastDeadline;
  String lunchDeadline;
  String dinnerDeadline;

  GetDeadLineData({this.breakfastDeadline, this.lunchDeadline, this.dinnerDeadline});

  GetDeadLineData.fromJson(Map<String, dynamic> json) {
    breakfastDeadline = json['breakfast_deadline'];
    lunchDeadline = json['lunch_deadline'];
    dinnerDeadline = json['dinner_deadline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['breakfast_deadline'] = this.breakfastDeadline;
    data['lunch_deadline'] = this.lunchDeadline;
    data['dinner_deadline'] = this.dinnerDeadline;
    return data;
  }
}

class PostdeadlineReturnModel {
  String code;
  String message;
  Null data;

  PostdeadlineReturnModel({this.code, this.message, this.data});

  PostdeadlineReturnModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}