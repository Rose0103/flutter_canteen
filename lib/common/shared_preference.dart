import 'package:shared_preferences/shared_preferences.dart';

class User{
  String _username;
  String _password;

  User(this._username,
      this._password);

  get username => _username;
  get password => _password;

  @override
  String toString() {
    return "|$_username $_password|";
  }

  @override
  bool operator ==(other) {
    return (_username == other._username) && (_password == other._password);
  }
}

class KeyConst {
  static String USER_NAME = "username";
  static String PASSWORD = "password";
  static String LOGIN = "login";
  static String USERTYPE= "usertype";
  static String MESSAGE="message";
  static String COOKIES="cookies";
  static String USERID="userid";
  static const String ACCOUNT_NUMBER = "account_number";
  static const String USERNAME_Total = "username_Total";
  static const String PASSWORD_Total = "password_Total";
  static const String CANTEEN_ID = "canteenID";
  static const String CANTEEN_NAME = "canteenName";


}

class KvStores {

  static save(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('不支持${value.runtimeType}类型');
    }
  }

  static dynamic get(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  static dynamic remove(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }

  ///删掉单个账号
  static void delUser(User user) async {
    List<User> list = await getUsers();
    list.remove(user);
    await saveUsers(list);
  }

  ///保存账号，如果重复，就将最近登录账号放在第一个
  static void saveUser(User user) async {
    List<User> list = await getUsers();
    await addNoRepeat(list, user);
    await saveUsers(list);
  }

  ///去重并维持次序
  static void addNoRepeat(List<User> users, User user) {
    if (users.contains(user)) {
      users.remove(user);
    }
    users.insert(0, user);
  }

  ///获取已经登录的账号列表
  static Future<List<User>> getUsers() async {
    List<User> list = new List();
    SharedPreferences sp = await SharedPreferences.getInstance();
    int num = sp.getInt(KeyConst.ACCOUNT_NUMBER) ?? 0;
    for (int i = 0; i < num; i++) {
      String username = sp.getString("${KeyConst.USERNAME_Total}$i");
      String password = sp.getString("${KeyConst.PASSWORD_Total}$i");
      if(username!=null&&!username.contains("null")&&password!=null&&!password.contains("null"))
      list.add(User(username, password));
      else
     {
      sp.remove("${KeyConst.USERNAME_Total}$i");
      sp.remove("${KeyConst.PASSWORD_Total}$i");
     }
    }
    return list;
  }

  ///保存账号列表
  static saveUsers(List<User> users) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    int num =0;
    if(null!=sp.getInt(KeyConst.ACCOUNT_NUMBER))
      {
        num=sp.getInt(KeyConst.ACCOUNT_NUMBER);
      }
    for (int i = 0; i < num; i++) {
      remove("${KeyConst.USERNAME_Total}$i");
      remove("${KeyConst.PASSWORD_Total}$i");
    }
    save(KeyConst.ACCOUNT_NUMBER, 0);
    int size = users.length;
    for (int i = 0; i < size; i++) {
      save("${KeyConst.USERNAME_Total}$i", users[i].username);
      save("${KeyConst.PASSWORD_Total}$i", users[i].password);

    }
    save(KeyConst.ACCOUNT_NUMBER, size);
  }
}
