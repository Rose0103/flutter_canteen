class ticketModel {
  String code;
  String message;
  List<Data> data;

  ticketModel({this.code, this.message, this.data});

  ticketModel.fromJson(Map<String, dynamic> json) {
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
  int ticketNum;
  String createTime;
  int consumerId;
  String consumerName;

  Data({this.ticketNum, this.createTime, this.consumerId, this.consumerName});

  Data.fromJson(Map<String, dynamic> json) {
    ticketNum = json['ticket_num'];
    createTime = json['create_time'];
    consumerId = json['consumer_id'];
    consumerName = json['consumer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_num'] = this.ticketNum;
    data['create_time'] = this.createTime;
    data['consumer_id'] = this.consumerId;
    data['consumer_name'] = this.consumerName;
    return data;
  }
}
