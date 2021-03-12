class UserAndCanteen{
  int user_id;
  int canteen_id;
  String canteen_name;
  UserAndCanteen({this.user_id,this.canteen_id,this.canteen_name});

  UserAndCanteen.map(dynamic obj){
    //this.visitTableColumnId = obj['id'];
    this.user_id = obj['user_id'];
    this.canteen_id = obj['canteen_id'];
    this.canteen_name = obj['canteen_name'];
  }

  int get _user_id=>user_id;
  int get _canteen_id=>canteen_id;
  String get _canteen_name=>canteen_name;

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['user_id'] = _user_id;
    map['canteen_id'] = _canteen_id;
    map['canteen_name'] = _canteen_name;
    return map;
  }

  UserAndCanteen.fromMap(Map<String , dynamic>map){
    this.user_id = map['user_id'];
    this.canteen_id = map['canteen_id'];
    this.canteen_name = map['canteen_name'];
  }
}