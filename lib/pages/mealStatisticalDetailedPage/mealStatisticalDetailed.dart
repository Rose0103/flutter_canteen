class MealStatisticalDetailed{
  int level;//等级
  String usName;//姓名
  String bcState;//饱餐状态
  String ycState;//用餐状态
  String count;//数量
  String eatcount;// 用餐数量
  String money;//金额
  String telPhone;//联系电话
  int state;//状态
  //modify by
  int orgID;
  String ticketNum;
  String bodyTemperature;
  String organizeName;
  int bodyTemperatureState;


  MealStatisticalDetailed(
    this.level,
    this.usName,
    this.bcState,
    this.ycState,
    this.count,
    this.eatcount,
    this.money,
    this.telPhone,
    this.state,
    //modify by
    this.orgID,
    this.ticketNum,
    this.bodyTemperature,
      this.organizeName,
      this.bodyTemperatureState

  );
}