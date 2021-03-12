import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_canteen/pages/personnelManagement/addnew_person_page1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_canteen/service/service_method.dart';
import 'personnelDetailed.dart';

class personnTableDataTableSource extends DataTableSource {

  BuildContext context;
  List<personnellDetailed> data;


  personnTableDataTableSource(this.data,this.context);
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
        DataCell(centerText('${index+1}',data[index].isEnabled)),
        DataCell(centerText('${data[index].usName}',data[index].isEnabled)),
        DataCell(centerText('${data[index].sex}',data[index].isEnabled)),
        DataCell(centerText('${data[index].phoneName}',data[index].isEnabled)),
        DataCell(centerText('${data[index].isemployee}',data[index].isEnabled)),
        DataCell(choseBtn(index)),
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

  Widget centerText(String text,bool color){
    return Text(
        text,
        style: TextStyle(
            fontSize:ScreenUtil().setSp(26),
            color: typeColor(color)
        )
    );
  }

  Widget choseBtn(int index){
    if(data[index].isEnabled){
      return new Row(
        children: <Widget>[
          InkWell(
            onTap: () {
             none = false;
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewPersonPage(data[index].userOrgId,ishead:true,cID: data[index].cID,)));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),
                alignment: Alignment.center,
                child: Text(
                  '编辑',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                    height: 1.4,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                )),
          ),
          InkWell(
            onTap: () {
              showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('请选择移除方式？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('禁用账号'),
                          onPressed: () {
                            print("4444:${data[index].cID}");
                            _getSumUser(data[index].cID,"0");
                          },
                        ),
                        FlatButton(
                          child: Text('从机构中移除'),
                          onPressed: () {

                            _updateUserOrg(data[index].userRootOrgId,data[index].cID);
                          },
                        ),
                      ],
                    );;
                  }
              );
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),

                alignment: Alignment.center,
                child: Text(
                  '移除',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                    height: 1.4,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                )),
          ),
        ],
      );
    }else {
     return new Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              _getSumUser(data[index].cID,"1");
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                padding: EdgeInsets.fromLTRB(18, 3, 18, 3),

                alignment: Alignment.center,
                child: Text(
                  '恢复',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    height: 1.4,
                    decoration: TextDecoration.none,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                )),
          )
        ],
      );
    }

  }
  Color typeColor(bool i){
    Color color;
    if(i){
      color = Colors.red;
    }else{
      color = Colors.grey;
    }
    return color;
  }

  Future _getSumUser(int userId,String state) async {
    var formData = {
      "is_enabled":state,
      "user_id":userId
    };
    await request('managementUserInfo', '',formData: formData).then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        String code = val['code'].toString();
        if(code=="0"){
          if(state=="0"){
            Navigator.of(context).pop(false);
            personnelRefreshBtn.onPressed();
          }else{
            personnelRefreshBtn.onPressed();
          }

        }
      }
    });
  }

  Future _updateUserOrg(int orgId,int userId) async {
    var formData = {
      "organize_id":orgId,
      "user_id":userId
    };
    print("object:${formData.toString()}");
    await request('managementUserInfo', '',formData: formData).then((val) {
      if (val.toString() == "false") {
        return;
      }
      if (val != null) {
        String code = val['code'].toString();
        if(code=="0"){
          Navigator.of(context).pop(false);
          personnelRefreshBtn.onPressed();
        }
      }
    });
  }
}