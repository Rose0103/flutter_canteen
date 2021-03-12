import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'existingPersonnelListDetailed.dart';

class existingPersonnTableDataTableSource extends DataTableSource {

  BuildContext context;
  List<existingPersonnelListDetailed> data;
  existingPersonnTableDataTableSource(this.data,this.context);
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
        DataCell(new Checkbox(
          value: data[index].selected,
          activeColor: Colors.blue,
          onChanged: (bool val) {
              data[index].selected = !data[index].selected;
              notifyListeners();
          },
        ),),
        DataCell(centerText('${data[index].usName}')),
        DataCell(centerText('${data[index].sex}')),
        DataCell(centerText('${data[index].phoneName}')),
        DataCell(centerText('${data[index].department}')),
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

  void getIndex(){
    print("4444444444444");
  }

  Widget centerText(String text){
    return Text(
        text,
        style: TextStyle(
            fontSize:ScreenUtil().setSp(26),
        )
    );
  }
}