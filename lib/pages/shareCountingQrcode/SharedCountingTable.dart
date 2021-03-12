import 'package:flutter/material.dart';
import 'package:flutter_canteen/config/param.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'sharedCounting.dart';

class SharedCountingTable extends DataTableSource {
  BuildContext context;
  List<sharedCounting> data;

  SharedCountingTable(this.data,this.context);

  DataRow getRow(int index) {
    if(data.length==0){
      return null;
    }
    if (index >= data.length) {
      return null;
    }
    if(counting == true){
      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(centerText("${data[index].name}")),
          DataCell(centerText("${data[index].counting}")),
          DataCell(centerText("${data[index].shareTime}")),
        ],
      );
    }else{
      return DataRow.byIndex(
        index: index,
        cells: [
          DataCell(centerText("${data[index].name}")),
          DataCell(centerText("${data[index].counting}")),
          DataCell(centerText("${data[index].shareTime}")),
        ],
      );
    }

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

  Widget centerText(String text){
    return Text(
        text,
        style: TextStyle(
            fontSize:ScreenUtil().setSp(26),
        )
    );
  }
}
