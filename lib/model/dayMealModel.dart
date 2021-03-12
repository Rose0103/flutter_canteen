/**
 * 一天的的数据
 */
class DayMealModel {
  String code;
  String message;
  Data data;

  DayMealModel({this.code, this.message, this.data});

  DayMealModel.fromJson(Map<String, dynamic> json) {
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
  Map<String, dynamic> detail;
  Count count;

  Data({this.detail, this.count});

  Data.fromJson(Map<String, dynamic> json) {
    // ignore: unnecessary_statements

    detail =
    json['detail'] != null ?json['detail']: null;
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detail != null) {
      data['detail'] = this.detail;
    }
    if (this.count != null) {
      data['count'] = this.count.toJson();
    }
    return data;
  }
}





class Breakfast {
int postEaten;
int postNeaten;
int npostEaten;

Breakfast({this.postEaten, this.postNeaten, this.npostEaten});

Breakfast.fromJson(Map<String, dynamic> json) {
postEaten = json['post_eaten'];
postNeaten = json['post_neaten'];
npostEaten = json['npost_eaten'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['post_eaten'] = this.postEaten;
data['post_neaten'] = this.postNeaten;
data['npost_eaten'] = this.npostEaten;
return data;
}
}

class Lunch {
int postEaten;
int postNeaten;
int npostEaten;

Lunch({this.postEaten, this.postNeaten, this.npostEaten});

Lunch.fromJson(Map<String, dynamic> json) {
postEaten = json['post_eaten'];
postNeaten = json['post_neaten'];
npostEaten = json['npost_eaten'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['post_eaten'] = this.postEaten;
data['post_neaten'] = this.postNeaten;
data['npost_eaten'] = this.npostEaten;
return data;
}
}

class Dinner {
int postEaten;
int postNeaten;
int npostEaten;

Dinner({this.postEaten, this.postNeaten, this.npostEaten});

Dinner.fromJson(Map<String, dynamic> json) {
postEaten = json['post_eaten'];
postNeaten = json['post_neaten'];
npostEaten = json['npost_eaten'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['post_eaten'] = this.postEaten;
data['post_neaten'] = this.postNeaten;
data['npost_eaten'] = this.npostEaten;
return data;
}
}

class Count {
Breakfast breakfast;
Lunch lunch;
Dinner dinner;

Count({this.breakfast, this.lunch, this.dinner});

Count.fromJson(Map<String, dynamic> json) {
breakfast = json['breakfast'] != null ? new Breakfast.fromJson(json['breakfast']) : null;
lunch = json['lunch'] != null ? new Lunch.fromJson(json['lunch']) : null;
dinner = json['dinner'] != null ? new Dinner.fromJson(json['dinner']) : null;
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
if (this.breakfast != null) {
data['breakfast'] = this.breakfast.toJson();
}
if (this.lunch != null) {
data['lunch'] = this.lunch.toJson();
}
if (this.dinner != null) {
data['dinner'] = this.dinner.toJson();
}
return data;
}
}