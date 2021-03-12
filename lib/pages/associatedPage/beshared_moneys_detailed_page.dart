import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/shareMoneyModel.dart';
import 'package:flutter_canteen/pages/associatedPage/shared_money_table.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BeSharedMoneysDetailedPage extends StatefulWidget {

  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  FocusNode focusNode3 = new FocusNode();
  BeSharedMoneysDetailedPage(this.focusNode1,this.focusNode2,this.focusNode3);

  @override
  _BeSharedMoneysDetailedPageState createState() => _BeSharedMoneysDetailedPageState();
}
class _BeSharedMoneysDetailedPageState extends State<BeSharedMoneysDetailedPage> {

  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  FocusNode _commentFocus = FocusNode(); //控制输入框焦点
  List<ShareMoney> moneyList = new List();//当前展示的记录
  List<ShareMoney> moneyAllList = new List();//接口后去的记录


  @override
  void initState() {
    _startController.text = DateTime.now().toString().split(" ")[0];
    _endController.text = DateTime.now().toString().split(" ")[0];
    getGiveMoneyHistory();
    super.initState();
  }

//查询转赠记录
  Future getGiveMoneyHistory() async{
    if(_startController.text==_endController.text){
      DateTime dateTime = DateTime.parse(_endController.text);
      _endController.text = dateTime.add(new Duration(days: 1)).toString().split(" ")[0];
    }
    if(DateTime.parse(_startController.text).isAfter(DateTime.parse(_endController.text))){
      String temp = _startController.text;
      _startController.text = _endController.text;
      _endController.text = temp;
    }
    String params = '?bill_type=4&start='+_startController.text+'&end='+_endController.text;
    await requestGet('getGiveMoneyHistory', params).then((val){
      if(val['code']=="0"){
        ShareMoneyModel shareMoneyModel = ShareMoneyModel.fromJson(val);
        String time;
        for(int i=0;i<shareMoneyModel.data.length;i++){
          time = shareMoneyModel.data[i].createTime;
          shareMoneyModel.data[i].createTime = time.replaceAll("T", " ").substring(0,time.length-4);
        }
        moneyList = shareMoneyModel.data;
        moneyAllList = shareMoneyModel.data;
        print(231321312);
        print(moneyAllList.length);
        setState(() {

        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              height: ScreenUtil().setSp(1300),
              alignment:Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30)),
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(15.0)),
                    child: timeDetailed(),//选择日期查询明细
                  ),
                  Expanded(child: SingleChildScrollView(
                    child: moneyAllList==null||moneyAllList.isEmpty?_nullDetailed()
                        :PaginatedDataTable(
                      header: searchDetailed(),
                      rowsPerPage:9,
                      columns: [
                        DataColumn(label: centerText('被转赠人')),
                        DataColumn(label: centerText('转赠人')),
                        DataColumn(label: centerText('金额（元）')),
                        DataColumn(label: centerText('日期')),
                      ],
                      source: SharedMoneyTable(moneyList,context),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  //选择日期查询明细Widget
  Widget timeDetailed(){
    return Container(
      height: ScreenUtil().setSp(60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("从: ", style: TextStyle(fontSize: ScreenUtil().setSp(32.0))),
          timeWidget(_startController, true),
          Text("  至: ", style: TextStyle(fontSize: ScreenUtil().setSp(32.0))),
          timeWidget(_endController, false),
          selectButton()
        ],
      ),
    );

  }

  //搜索查询明细 Widget
  Widget searchDetailed(){
    return  Container(
      height: ScreenUtil().setSp(80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: ScreenUtil().setSp(590),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(width: ScreenUtil().setSp(2),color: Colors.black12)
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: ScreenUtil().setSp(30.0)),
                          decoration: new InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  fontWeight: FontWeight.w500
                              ),
                              hintText: '请输入转赠人或被转赠人', border: InputBorder.none),
                          onChanged:(v) async{
                            print(v);
                            List<ShareMoney> list = new List();
                            for(int i=0;i<moneyAllList.length;i++){
                              if(moneyAllList[i].consumerName.contains(_nameController.text)||moneyAllList[i].operatorName.contains(_nameController.text)){
                                list.add(moneyAllList[i]);
                              }
                            }
                            moneyList = list;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      icon: new Icon(Icons.cancel),
                      color: Colors.grey,
                      iconSize: 18.0,
                      onPressed: () {
                        _nameController.clear();
                        moneyList = moneyAllList;
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {

                        });

                      },
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget timeWidget(TextEditingController controller,bool flag) {
    return Container(
      width: ScreenUtil().setSp(216),
      child: TextFormField(
          focusNode: _commentFocus,
          readOnly: true,
          autofocus: false,
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            fillColor: Theme
                .of(context)
                .primaryColor,
            border: OutlineInputBorder(),
          ),
          onTap: () {
            _commentFocus.unfocus(); // 失去焦点
            _showPicker(flag);
            // print(_startController.text);
          }),
    );
  }

  Widget selectButton(){
    return Container(
        margin: EdgeInsets.only(left: ScreenUtil().setSp(10)),
        width: ScreenUtil().setSp(120),
        child:RaisedButton(
            child: Text("查询",style: TextStyle(color: Colors.orange, fontSize: ScreenUtil().setSp(32))),
            colorBrightness: Brightness.light,
            splashColor: Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
            padding: EdgeInsets.all(0.0),
            onPressed: () async {
              print(_startController.text);
              await getGiveMoneyHistory();
            }
        )
    );
  }


  _showPicker(bool flag) {
    DatePicker.showDatePicker(
      context,
      //最小值
      minDateTime: DateTime.now().add(Duration(days: -365 * 99)),
      //最大值
      maxDateTime: DateTime.now(),
      //默认日期
      initialDateTime: _startController.text
          .split("-")
          .length != 3 ? DateTime.now() :
      DateTime(int.parse(_startController.text.split("-")[0]),
          int.parse(_startController.text.split("-")[1]),
          int.parse(_startController.text.split("-")[2])),
      dateFormat: 'yyyy-MM-dd',
      locale: DateTimePickerLocale.zh_cn,
      pickerMode: DateTimePickerMode.date,
      //选择器种类
      onCancel: () {},
      onClose: () {},
      onChange: (date, i) {
        print(date);
      },
      onConfirm: (date, i) {
        if(flag){
          _startController.text = date.toString().split(" ")[0];
        }else{
          _endController.text = date.toString().split(" ")[0];
        }
        setState(() {

        });
      },
    );
  }

  Widget centerText(String text){
    return Center(
      child: Text(
          text,
          style: TextStyle(
              fontSize:ScreenUtil().setSp(26),
              fontWeight: FontWeight.w600
          )
      ),
    );
  }

  Widget _nullDetailed(){
    return Container(
        margin: EdgeInsets.only(top: ScreenUtil().setSp(200.0)),
        child: Column(
          children: <Widget>[
            Image.asset("assets/images/null.png",width: ScreenUtil().setSp(300.0),height: ScreenUtil().setSp(300.0),fit: BoxFit.fill,),
            Container(
              child: Text("暂无记录明细",style: TextStyle(color:Colors.black26,fontWeight:FontWeight.w500,fontSize: ScreenUtil().setSp(32)),),
            )
          ],
        )
    );
  }
}
