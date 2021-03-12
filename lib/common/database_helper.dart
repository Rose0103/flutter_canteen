import 'dart:async';
import 'dart:io';
import 'package:flutter_canteen/model/userandCanteen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static Database _db;
  //食堂关联表
  final String recordtable = 'userCanteenTable';
  final String userTableColumnId = 'user_id';//用户ID
  final String canteenId = 'canteen_id';//食堂ID
  final String canteenName = 'canteen_name';//食堂名称

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }

    _db = await intDB();
    return _db;
  }

  intDB() async{
    //Directory documentDirectory = await getApplicationDocumentsDirectory();
    Directory documentDirectory = await getExternalStorageDirectory();
    String path = join(documentDirectory.path , 'visitor.db');
    var myOwnDB = await openDatabase(path,version: 1,
        onCreate: _onCreate);
    return myOwnDB;
  }

  //创建表
  void _onCreate(Database db , int newVersion) async{
    var sql = "CREATE TABLE $recordtable ($userTableColumnId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$canteenId INTEGER, $canteenName VARCHAR(20))";
    await db.execute(sql);
  }

  //增加主记录表数据
  Future<int> saveRecord(UserAndCanteen info) async{
    var dbClient = await  db;
    int result = await dbClient.insert("$recordtable", info.toMap());
    return result;
  }

  //查询主记录表数据
  Future<UserAndCanteen> getCanteenByUserId(int user_id) async{
    var dbClient = await  db;
    var sql = "SELECT * FROM $recordtable WHERE $user_id = $userTableColumnId";
    List result = await dbClient.rawQuery(sql);
    UserAndCanteen user;
    if(result!=null&&result.length>0){
      user = UserAndCanteen.fromMap(result[0]);
    }
    return user;
  }

  Future<int> getCount() async{
    var dbClient = await  db;
    var sql = "SELECT COUNT(*) FROM $recordtable";
    return  Sqflite.firstIntValue(await dbClient.rawQuery(sql)) ;
  }

  //清空表数据
  Future deleteRecordsAll() async{
    var dbClient = await  db;
    var sql = "DELETE FROM $recordtable";
    List result  = await dbClient.rawQuery(sql);
    return  result; ;
  }

  //更新主记录表数据
  Future<int> updateRecord(UserAndCanteen info) async{
    var dbClient = await  db;
    return  await dbClient.update(
        recordtable ,info.toMap(), where: "$userTableColumnId = ?" , whereArgs: [info.user_id]
    );
  }

  //删除主记录表数据
  Future<int> deleteRecord(int id) async{
    var dbClient = await  db;
    return  await dbClient.delete(
        recordtable , where: "$userTableColumnId = ?" , whereArgs: [id]
    );
  }

  Future close() async{
    var dbClient = await  db;
    return  await dbClient.close();
  }


}