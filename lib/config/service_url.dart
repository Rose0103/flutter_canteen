import 'param.dart';
const serviceUrl = 'http://106.13.88.69:7300/mock/5d9d3b2b7add29001ff4f8a7/ygst/';
const serviceUrl2 = 'http://v.jspang.com:8088/baixing/';
// const serviceUrltest = 'http://106.12.144.158:8000/';
const serviceUrltest = "http://$serverIP/";  //测试环境
// const serviceUrl2test = 'http://106.12.144.158:10001/';


const servicePath = {
  //管理端主页面接口
  'managerHomePageContext': serviceUrltest + 'api/resources/get/management/home/page',
  //用户端主页面接口
  'clientHomePage': serviceUrltest + 'api/resources/get/user/home/page',
  //登录接口
  'loginByUsername': serviceUrltest + 'api/user/login',
  //手机号是否已注册
  'phomeNumCheck': serviceUrltest + 'api/user/check',
  //注册接口
  'register': serviceUrltest + 'api/user/register',
  //获取短信验证码接口
  'getmessageCode': serviceUrltest + 'api/user/code',
  //修改密码接口
  'resetPasswd': serviceUrltest + 'api/user/reset',
  //获取用户信息接口
  'getUserInfo': serviceUrltest + 'api/user/get/info',
  //修改用户信息接口
  'postUserInfo': serviceUrltest + 'api/user/put/info',
  //获取用户兴趣接口
  'getUserHabbitInfo': serviceUrltest + 'api/user/get/hobby',
  //提交用户兴趣接口
  'postUserHabbitInfo': serviceUrltest + 'api/user/put/hobby',
  //餐厅名模糊查询
  'searchcanteenname': serviceUrltest + 'api/management/match/canteen',
  //报餐状态查询接口
  'getOrderPreState': serviceUrltest + 'api/user/meal/get',
  //'modifyOrderPre': serviceUrltest + 'api/user/meal/addorupdate',
  //修改报餐状态信息(老接口，弃用)
  //新增更新报餐状态
  'addOrUpdateOrderState':serviceUrltest + 'api/user/meal/post',
  //新增更新订餐状态
  'addOrUpdateDingCanState':serviceUrltest + 'api/user/meal/order',
  //根据食堂ID获取食堂价格
  'getCanteenExtById': serviceUrltest + 'api/canteen/getCanteenExtById',
  //多个菜品查询接口api/management/food/put/menu
  'getFoodDish': serviceUrltest + 'api/management/food/get/dish',
  //菜单发布列表提交接口
  'foodMenuRelease': serviceUrltest + 'api/management/food/put/menu',
  //菜品排行查询接口
  'foodScore': serviceUrltest + 'api/management/food/get/score',
  //菜品发布提交接口
  'foodEntry': serviceUrltest + 'api/management/food/put/dish',
  //一二级菜品列表获取或删除接口',
  'Category': serviceUrltest + 'api/management/food/category',
  //创建目录列表
  'CreateCategory':serviceUrltest + 'api/management/food/create/category',
  //单个菜品详情及评论信息查询接口
  'foodEvaluation': serviceUrltest + 'api/user/meal/get/comment',
  //菜单列表查询接口
  'foodMenuForDay': serviceUrltest + 'api/management/food/get/menu',
  //个人历史订单查询接口
  'personalSumaryData': serviceUrl + 'api/user/meal/list',
  //根据时间段获取报餐状态列表
  'getMonthSummaryData': serviceUrltest + 'api/management/food/get/statistics',
  //提交评论接口
  'mealListData': serviceUrltest + 'api/user/meal/list',
  //报餐统计详细
  'postComment': serviceUrltest+'api/user/meal/put/comment',
  //用户
  'userMeal': serviceUrltest+'api/user/meal/get',
  //商品列表
  'managementUserInfo': serviceUrltest+'api/management/user/info',
  //充值餐券
  'recharges':serviceUrltest + 'api/bill/ticket/recharge',
  //提交爱心商店资料
  'managementStoreList': serviceUrltest+'api/management/store/list',
  //获取评论提交评论',
  'managementStorePutInfo': serviceUrltest+'api/management/store/put/info',
  //提交报餐截止时间
  'boardContent': serviceUrltest + 'api/user/board/content',
  'deadline':serviceUrltest + 'api/management/food/put/deadline',
  //获取报餐截至时间
  'getdeadline':serviceUrltest + 'api/management/food/deadline',
  //用户账单查询
  'getbills':serviceUrltest + 'api/bill/detail',
  //报餐价格设置(post)及查询(get)
  'systemconfig':serviceUrltest + 'api/resources/config/info',
  //升级信息获取
  'updateversion':serviceUrltest + 'api/resources/client/version',
  //充值
  'recharge':serviceUrltest + 'api/bill/recharge',
  //管理端确认或拒绝订餐
  'order':serviceUrltest + 'api/management/meal/order',
  //用户等级设置
  'userlevel':serviceUrltest + 'api/management/user/level',
  //获取组织信息
  'getorganizeinfo':serviceUrltest + 'api/management/organize',
  //根据单位获取已关联食堂  ?type=canteen  根据食堂获取已关联单位  ?type=organize
  'getauthorization':serviceUrltest + 'api/management/canteen/authorization',
  //获取人脸
  'getFeature':serviceUrltest + 'api/resources/face/feature/get',
  //查询赠券记录
  'getTicket':serviceUrltest + 'api/bill/ticket/history',
  //分享餐券
  'tichetGive':serviceUrltest + 'api/bill/ticket/give',

  //转赠金额
  'moneyGive':serviceUrltest + 'api/bill/money/give',
  //查询转赠记录
  'getGiveMoneyHistory':serviceUrltest + 'api/bill/money/history',


};
