class existingPersonnelListDetailed {
  String usName; //姓名
  String sex; //性别
  String phoneName; //电话号码
  String department; //是否员工
  String money;
  int cID;
  bool selected;

  existingPersonnelListDetailed(
      this.usName, this.sex, this.phoneName, this.department, this.cID,this.money,{this.selected = false});
}
