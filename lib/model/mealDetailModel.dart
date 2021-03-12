import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mealDetailModel {
  String code;
  String message;
  List<Data> data;

  mealDetailModel({this.code, this.message, this.data});

  mealDetailModel.fromJson(Map<String, dynamic> json) {
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
  int mealstatId;
  int userId;
  String orderDate;
  int mealType;
  int quantity;
  int eatquantity;
  int state;
  double price;
  int diningStatus;
  int canteen_id;
  int ticket_num;
  List<BodyTemperature> bodyTemperature;

  Data(
      {this.mealstatId,
        this.userId,
        this.orderDate,
        this.mealType,
        this.quantity,
        this.eatquantity,
        this.state,
        this.price,
        this.diningStatus,
        this.canteen_id,
        this.ticket_num,
        this.bodyTemperature
      });

  Data.fromJson(Map<String, dynamic> json) {
    mealstatId = json['mealstat_id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    mealType = json['meal_type'];
    quantity = json['quantity'];
    eatquantity = json['eaten_quantity'];
    state = json['state'];
    price = double.parse(json['price'].toString());
    diningStatus = json['dining_status'];
    canteen_id = json['canteen_id'];
    ticket_num = json['ticket_num'];
    if (json['body_temperature'] != null) {
      bodyTemperature = new List<BodyTemperature>();
      json['body_temperature'].forEach((v) {
        bodyTemperature.add(new BodyTemperature.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mealstat_id'] = this.mealstatId;
    data['user_id'] = this.userId;
    data['order_date'] = this.orderDate;
    data['meal_type'] = this.mealType;
    data['quantity'] = this.quantity;
    data['eaten_quantity'] = this.eatquantity;
    data['state'] = this.state;
    data['price'] = this.price;
    data['dining_status'] = this.diningStatus;
    data['canteen_id'] = this.canteen_id;
    data['ticket_num'] = this.ticket_num;
    if (this.bodyTemperature != null) {
      data['body_temperature'] =
          this.bodyTemperature.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyTemperature {
  String checkId;
  int userId;
  String createTime;
  String updateTime;
  double temperature;
  int scale;
  int mealstatId;
  int rootOrganizeId;

  BodyTemperature(
      {this.checkId,
        this.userId,
        this.createTime,
        this.updateTime,
        this.temperature,
        this.scale,
        this.mealstatId,
        this.rootOrganizeId});

  BodyTemperature.fromJson(Map<String, dynamic> json) {
    checkId = json['check_id'];
    userId = json['user_id'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    temperature = json['temperature'];
    scale = json['scale'];
    mealstatId = json['mealstat_id'];
    rootOrganizeId = json['root_organize_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_id'] = this.checkId;
    data['user_id'] = this.userId;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['temperature'] = this.temperature;
    data['scale'] = this.scale;
    data['mealstat_id'] = this.mealstatId;
    data['root_organize_id'] = this.rootOrganizeId;
    return data;
  }
}
