class MineOrderItem {
  //就餐时间
  String time;
  //报点状态   已报餐 未报餐
  int state;
  int laststate;
  int int_mealtype;

  String mealType;

  //订单编号
  String orderNumber;

  //报餐食堂
  int canteenID;
  String caName;

  //用餐类型  早中晚？
  String goMealType;

  //报餐数量
  String mealsNum;

  //就餐数量
  String dingmealsNum;

  //用餐价格
  String mealsPrice;

  //就餐状态
  String diningType;
  //用餐单价
  String mealsUnitPrice;

  //上次选择数量
  String lastnum;

  //支付方式
  int costType;

  //餐券数量
  int ticketNum;
}
