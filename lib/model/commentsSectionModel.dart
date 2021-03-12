class CommentsSectionModel {
  String code;
  String message;
  List<Data> data;

  CommentsSectionModel({this.code, this.message, this.data});

  CommentsSectionModel.fromJson(Map<String, dynamic> json) {
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
  String createTime;
  int userId;
  String boardContent;
  String userName;
  int boardType;

  Data(
      {this.createTime,
        this.userId,
        this.boardContent,
        this.userName,
        this.boardType});

  Data.fromJson(Map<String, dynamic> json) {
    createTime = json['create_time'];
    userId = json['user_id'];
    boardContent = json['board_content'];
    userName = json['user_name'];
    boardType = json['board_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['create_time'] = this.createTime;
    data['user_id'] = this.userId;
    data['board_content'] = this.boardContent;
    data['user_name'] = this.userName;
    data['board_type'] = this.boardType;
    return data;
  }
}