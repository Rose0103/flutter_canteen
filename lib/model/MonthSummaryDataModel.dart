class MonthSummaryDataModel {
  String code;
  String message;
  mouthData data;

  MonthSummaryDataModel({this.code, this.message, this.data});

  MonthSummaryDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new mouthData.fromJson(json['data']) : null;
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

class mouthData {
  List<sumaryDateData> detaildata;
  SummaryData count;

  mouthData({this.detaildata, this.count});

  mouthData.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      var arr0 = List<sumaryDateData>();
      Map<String, dynamic>.from(json['detail']).forEach((f, v) {
        print(f);
        print(v);
        SummaryData temp = new SummaryData.fromJson(v);
        sumaryDateData tempdatedata = new sumaryDateData(f, temp);
        arr0.add(tempdatedata);
      });
      detaildata = arr0;
    }
    count =
        json['count'] != null ? new SummaryData.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.detaildata != null) {
      data['detail'] = this.detaildata;
    }
    if (this.count != null) {
      data['count'] = this.count.toJson();
    }
    return data;
  }
}

class sumaryDateData {
  String date;
  SummaryData summaryData;

  sumaryDateData(this.date, this.summaryData);
}

class SummaryData {
  Mealdata breakfast;
  Mealdata lunch;
  Mealdata dinner;

  SummaryData({this.breakfast, this.lunch, this.dinner});

  SummaryData.fromJson(Map<String, dynamic> json) {
    breakfast = json['breakfast'] != null
        ? new Mealdata.fromJson(json['breakfast'])
        : null;
    lunch = json['lunch'] != null ? new Mealdata.fromJson(json['lunch']) : null;
    dinner =
        json['dinner'] != null ? new Mealdata.fromJson(json['dinner']) : null;
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

class Mealdata {
  int postEaten;
  int postNeaten;
  int npostEaten;
  int remainEaten;
  int remainNeaten;
  int upostEaten;

  Mealdata({this.postEaten, this.postNeaten, this.npostEaten,this.remainEaten,this.remainNeaten,this.upostEaten});

  Mealdata.fromJson(Map<String, dynamic> json) {
    postEaten = json['post_eaten'];
    postNeaten = json['post_neaten'];
    npostEaten = json['npost_eaten'];
    remainEaten=json['remain_eaten'];
    remainNeaten=json['remain_neaten'];
    upostEaten = json['upost_eaten'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_eaten'] = this.postEaten;
    data['post_neaten'] = this.postNeaten;
    data['npost_eaten'] = this.npostEaten;
    data['remain_eaten'] = this.remainEaten;
    data['remain_neaten'] = this.remainNeaten;
    data['upost_eaten'] = this.upostEaten;
    return data;
  }
}
