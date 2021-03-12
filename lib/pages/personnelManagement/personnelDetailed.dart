class personnellDetailed {
  String usName; //姓名
  String sex; //性别
  String phoneName; //电话号码
  String isemployee; //是否员工
  int cID;
  int userRootOrgId;
  bool selected;
  bool isEnabled;
  int userOrgId;

  personnellDetailed(
      this.usName, this.sex, this.phoneName, this.isemployee, this.cID,this.userRootOrgId,this.isEnabled,this.userOrgId,{this.selected = false});
}


