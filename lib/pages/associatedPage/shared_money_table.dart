import 'package:flutter/material.dart';
import 'package:flutter_canteen/model/shareMoneyModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedMoneyTable extends DataTableSource {
  BuildContext context;
  List<ShareMoney> data;

  SharedMoneyTable(this.data,this.context);

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
          DataCell(centerText("${data[index].consumerName}")),
          DataCell(centerText("${data[index].operatorName}")),
          DataCell(centerText("${data[index].billPrice}")),
          DataCell(centerText("${data[index].createTime}")),
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

  Widget centerText(String text){
    return Text(
        text,
        style: TextStyle(
          fontSize:ScreenUtil().setSp(26),
        )
    );
  }
}
