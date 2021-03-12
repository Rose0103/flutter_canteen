import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mealStatisticalDetailed.dart';
import 'mealStatisticalDetailedPage.dart';

class TableDataTableSource extends DataTableSource {
  TableDataTableSource(this.data,this.context);
  BuildContext context;
  List<MealStatisticalDetailed> data;
  DataRow getRow(int index) {
    if(data.length==0){
      return null;
    }
    if (index >= data.length) {
      return null;
    }
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(centerText(data[index].level>0?'*${index+101}':'${index+101}', data[index].state)),
        DataCell(centerText('${data[index].usName}', data[index].state)),
        DataCell(centerText('${data[index].bcState}', data[index].state)),
        DataCell(centerText('${data[index].ycState}', data[index].ycState=="未用餐"?0:1)),
        DataCell(centerText('${data[index].eatcount}', data[index].state)),
        DataCell(centerText('${data[index].money}', data[index].state)),
        DataCell(centerText('${data[index].ticketNum}', data[index].state)),
        DataCell(centerText('${data[index].bodyTemperature}', data[index].bodyTemperatureState)),
        DataCell(centerText('${data[index].organizeName}', data[index].state)),
        DataCell(GestureDetector(
          child:centerText('${data[index].telPhone}', data[index].state)),
          onTap: () {
            _launchPhone(data[index].telPhone);
          },
        ),
        // DataCell(
        //   data[index].level>0?Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     crossAxisAlignment: CrossAxisAlignment.end,
        //     children: <Widget>[
        //       data[index].level==1?Text(""):
        //       Container(
        //         width: ScreenUtil().setSp(120),
        //         height: ScreenUtil().setSp(60),
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular((20.0)),
        //           color: Colors.amberAccent,
        //         ),
        //         margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        //         child: InkWell(
        //           child: centerText("↑", 1),
        //           onTap: () {
        //             MealStatisticalDetailedStates.rankUp.onPressed();
        //           },
        //         ),
        //       ),
        //       data[index].level==mapVIP.length?Text(""):
        //       Container(
        //         width: ScreenUtil().setSp(120),
        //         height: ScreenUtil().setSp(60),
        //         decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular((20.0)),
        //           color: Colors.amberAccent,
        //         ),
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        //         child: InkWell(
        //           child: centerText("↓", 2),
        //           onTap: () {
        //             MealStatisticalDetailedStates.rankDown.onPressed();
        //           },
        //         ),
        //       ),
        //       Container(
        //         width: ScreenUtil().setSp(120),
        //         height: ScreenUtil().setSp(60),
        //         decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular((20.0)),
        //           color: Colors.amberAccent,
        //         ),
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        //         child: InkWell(
        //           child: centerText("取关", 3),
        //           onTap: () {
        //             MealStatisticalDetailedStates.cancelUserVIP.onPressed();                },
        //         ),
        //       ),
        //     ]):Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     //crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Container(
        //         width: ScreenUtil().setSp(120),
        //         height: ScreenUtil().setSp(60),
        //         decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular((20.0)),
        //           color: Colors.amberAccent,
        //         ),
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        //         child: InkWell(
        //           child: centerText("关注 ", 1),
        //           onTap: () {
        //             MealStatisticalDetailedStates.focusUserVIP.onPressed();
        //           },
        //         ),
        //       ),
        //       Container(
        //         width: ScreenUtil().setSp(120),
        //         height: ScreenUtil().setSp(60),
        //         alignment: Alignment.center,
        //         margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        //         decoration: BoxDecoration(
        //           borderRadius: new BorderRadius.circular((20.0)),
        //           color: Colors.amberAccent,
        //         ),
        //         child: InkWell(
        //           child: centerText(" 置顶 ", 3),
        //           onTap: () {
        //             MealStatisticalDetailedStates.topUserVIP.onPressed();
        //           },
        //         ),
        //       ),
        //     ]
        //   ),
        // )
      ],
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data.length;
  }

  Color typeColor(int i){
    Color color = i==2?Colors.blue:i==1?Colors.green:i==0?Colors.red:Colors.purple;
    return color;
  }

  //拨打手机号码
  _launchPhone(phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget centerText(String text,int color){
    return Text(
        text,
        style: TextStyle(
            fontSize:ScreenUtil().setSp(26),
            color: typeColor(color)
        )
    );
  }
}