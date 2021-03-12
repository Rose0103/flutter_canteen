class homePageDataModel {
  String code;
  String message;
  homepageDetailData data;

  homePageDataModel({this.code, this.message, this.data});

  homePageDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new homepageDetailData.fromJson(json['data']) : null;
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

class homepageDetailData {
  String canteenName;
  String canteenID;
  List<Slides> slides;
  List<Category> category;

  homepageDetailData({this.canteenName, this.canteenID, this.slides, this.category});

  homepageDetailData.fromJson(Map<String, dynamic> json) {
    canteenName = json['canteenName'];
    canteenID = json['canteenID'];
    if (json['slides'] != null) {
      slides = new List<Slides>();
      json['slides'].forEach((v) {
        slides.add(new Slides.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['canteenName'] = this.canteenName;
    data['canteenID'] = this.canteenID;
    if (this.slides != null) {
      data['slides'] = this.slides.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slides {
  String image;
  String slideName;
  String pageName;
  String functionId;

  Slides({this.image, this.slideName, this.pageName, this.functionId});

  Slides.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    slideName = json['slideName'];
    pageName = json['pageName'];
    functionId = json['function_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['slideName'] = this.slideName;
    data['pageName'] = this.pageName;
    data['function_id'] = this.functionId;
    return data;
  }
}

class Category {
  String image;
  String categoryName;
  String pageName;
  String functionId;

  Category({this.image, this.categoryName, this.pageName, this.functionId});

  Category.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    categoryName = json['categoryName'];
    pageName = json['pageName'];
    functionId = json['function_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['categoryName'] = this.categoryName;
    data['pageName'] = this.pageName;
    data['function_id'] = this.functionId;
    return data;
  }
}