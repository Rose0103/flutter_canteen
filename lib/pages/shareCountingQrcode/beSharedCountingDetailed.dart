import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/ticketModel.dart';
import 'package:flutter_canteen/pages/shareCountingQrcode/sharedCounting.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'SharedCountingTable.dart';

class beSharedCountingDetailedPage extends StatefulWidget {
  FocusNode focusNode1 = new FocusNode();
  FocusNode focusNode2 = new FocusNode();
  beSharedCountingDetailedPage(this.focusNode1,this.focusNode2);
  @override
  _beSharedCountingDetailedPageState createState() => _beSharedCountingDetailedPageState();
}

List<sharedCounting> countingList = new List();
List<sharedCounting> sendList = new List();
List<sharedCounting> receiveList = new List();

class _beSharedCountingDetailedPageState extends State<beSharedCountingDetailedPage> {
  List<DropdownMenuItem> _item = new List();
  String hintStr = "我分享的";

  @override
  void initState() {
    widget.focusNode1.unfocus();
    widget.focusNode2.unfocus();
    _item.clear();
    _item.add(
      new DropdownMenuItem(
          value: 1,
          child: Text(
              '我分享的',
              style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
          )
      ),
    );
    _item.add(
      new DropdownMenuItem(
          value: 2,
          child: Text(
              '我收到的',
              style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
          )
      ),
    );
    countingList.clear();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await getTicketSend();
      await getTicketReceive();
      countingList = sendList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenUtil().setSp(1300),
        alignment:Alignment.topCenter,
        child:countingList.length == 0
            ?_nullDetailed()
            :Column(
          children: <Widget>[
            Expanded(child: SingleChildScrollView(
              child: PaginatedDataTable(
                header: Row(
                  children: <Widget>[
                    Container(
                      child: Container(
                        child: Text("餐券明细",style: TextStyle(fontWeight:FontWeight.w500,color: Colors.red, fontSize: ScreenUtil().setSp(36))),
                      ),
                    ),
                    //modify by
                    Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setSp(240)),
                        height: ScreenUtil().setSp(90.0),
                        child: DropdownButton(
                          items: _item,
                          hint: Text(
                              hintStr,
                              style: TextStyle(fontWeight:FontWeight.w500, fontSize: ScreenUtil().setSp(36))
                          ),
                          onChanged: (value){
                            setState(() {
                              if(value==1){
                                hintStr = '我分享的';
                                countingList = sendList;
                              }
                              if(value==2){
                                hintStr = '我收到的';
                                countingList = receiveList;
                              }
                            });
                          },
                        )
                    )
                  ],
                ),
                rowsPerPage:10,
                columns: [
                  DataColumn(label: centerText('姓名         ')),
                  DataColumn(label: centerText('餐券（张）')),
                  DataColumn(label: centerText('日期')),
                ],
                source: SharedCountingTable(countingList,context),
              ),
            )
            )
          ],
        ),
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

  //查询赠券记录（send_type=send）我送给别人的
  Future getTicketSend() async {
    await requestGet('getTicket', '?ticket_type=4&send_type=send' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      if(val != null){
        sendList.clear();
        setState(() {
          var ticketData = ticketModel.fromJson(val);
          if(ticketData != null && ticketData.data.length > 0){
            ticketData.data.forEach((f){
              sendList.add(
                  sharedCounting(
                      f.consumerName.toString(),
                      f.ticketNum,
                      f.createTime.replaceAll("T", " ").substring(0,f.createTime.indexOf("."))
                  )
              );
            });
            sharedCounting s;
            for(int i=0;i<sendList.length-1;i++){
              for(int j=i+1;j<sendList.length;j++){
                if(sendList[i].shareTime.compareTo(sendList[j].shareTime)<0){
                  s = sendList[i];
                  sendList[i] = sendList[j];
                  sendList[j] = s;
                }
              }
            }
          }

        });
      }
    });
  }

  //查询赠券记录(send_type=receive)  别人送给我的
  Future getTicketReceive() async {
    await requestGet('getTicket', '?ticket_type=4&send_type=receive' ).then((val)async{
      if(val.toString() == "false"){
        return;
      }
      if(val != null){
        receiveList.clear();
        setState(() {
          var ticketData = ticketModel.fromJson(val);
          if(ticketData != null && ticketData.data.length > 0){
            ticketData.data.forEach((f){
              receiveList.add(
                  sharedCounting(
                      f.consumerName.toString(),
                      f.ticketNum,
                      f.createTime.replaceAll("T", " ").substring(0,f.createTime.indexOf("."))
                  )
              );
            });
            sharedCounting s;
            for(int i=0;i<receiveList.length-1;i++){
              for(int j=i+1;j<receiveList.length;j++){
                if(receiveList[i].shareTime.compareTo(receiveList[j].shareTime)<0){
                  s = receiveList[i];
                  receiveList[i] = receiveList[j];
                  receiveList[j] = s;
                }
              }
            }
          }

        });
      }
    });
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
}
