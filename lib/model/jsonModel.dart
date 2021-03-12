class JsonModel{
  String user_id;
  String time;
  int num;
  String meal_type;
  String organize_Id;
  String root_organize_Id;
  Map toJson() {
    Map map = new Map();
    map["user_id"] = this.user_id;
    map["time"] = this.time;
    map["num"] = this.num;
    map["meal_type"] = this.meal_type;
    map["organize_Id"] = this.organize_Id;
    map["root_organize_Id"] = this.root_organize_Id;
    return map;
  }

}