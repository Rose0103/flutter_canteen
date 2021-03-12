class organizeListModel {
  String code;
  String message;
  List<OrganizeData> data;

  organizeListModel({this.code, this.message, this.data});

  organizeListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<OrganizeData>();
      json['data'].forEach((v) {
        data.add(new OrganizeData.fromJson(v));
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

class OrganizeData {
  int organizeid;
  String organizeiname;
  String organizeaddr;
  int parentorganizeid;
  int state;
  String createtime;
  String updatetime;
  int rootorganizeid;
  int orglevel;

  OrganizeData(
    this.organizeid,
    this.organizeiname,
    this.organizeaddr,
    this.parentorganizeid,
    this.state,
    this.createtime,
    this.updatetime,
    this.rootorganizeid,
    this.orglevel
  );

  OrganizeData.fromJson(Map<String, dynamic> json) {
    organizeid = json['organize_id'];
    organizeiname = json['organize_name'];
    organizeaddr = json['organize_addr'];
    parentorganizeid = json['parent_organize_id'];
    state = json['state'];
    createtime = json['create_time'];
    updatetime = json['update_time'];
    rootorganizeid = json['root_organize_id'];
    orglevel = json['org_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organize_id'] = this.organizeid;
    data['organize_name'] = this.organizeiname;
    data['organize_addr'] = this.organizeaddr;
    data['parent_organize_id'] =this.parentorganizeid;
    data['state'] =this.state;
    data['create_time'] =this.createtime;
    data['update_time'] =this.updatetime;
    data['root_organize_id'] =this.rootorganizeid;
    data['org_level'] =this.orglevel;
    return data;
  }
}
