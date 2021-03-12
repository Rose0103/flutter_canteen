class ShareMoneyModel {
  String code;
  String message;
  List<ShareMoney> data;

  ShareMoneyModel({this.code, this.message, this.data});

  ShareMoneyModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ShareMoney>();
      json['data'].forEach((v) {
        data.add(new ShareMoney.fromJson(v));
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

class ShareMoney {
  String billPrice;
  String createTime;
  int consumerId;
  int operatorId;
  String consumerName;
  String operatorName;

  ShareMoney(
      {this.billPrice,
        this.createTime,
        this.consumerId,
        this.operatorId,
        this.consumerName,
        this.operatorName});

  ShareMoney.fromJson(Map<String, dynamic> json) {
    billPrice = json['bill_price'];
    createTime = json['create_time'];
    consumerId = json['consumer_id'];
    operatorId = json['operator_id'];
    consumerName = json['consumer_name'];
    operatorName = json['operator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_price'] = this.billPrice;
    data['create_time'] = this.createTime;
    data['consumer_id'] = this.consumerId;
    data['operator_id'] = this.operatorId;
    data['consumer_name'] = this.consumerName;
    data['operator_name'] = this.operatorName;
    return data;
  }
}