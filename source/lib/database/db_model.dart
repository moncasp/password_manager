import 'package:flutter/cupertino.dart';

class DBModel {
  int id;
  String username;
  String email;
  String password;
  String category;
  String title;

  DBModel.withID(
  {@required this.id,@required this.username,@required this.email,@required this.password,@required this.title,@required this.category});

  DBModel({@required this.username,@required this.email,@required this.password,@required this.title,@required this.category});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["email"] = email;
    map["password"] = password;
    map["category"] = category;
    map["title"] = title;
    return map;
  }

  DBModel.fromMap(Map<String, dynamic> value) {
    this.id = value["id"];
    this.username = value["username"];
    this.email = value["email"];
    this.title = value["title"];
    this.password=value["password"];
    this.category = value["category"];
  }

  @override
  String toString() {
    return 'DBModel{id: $id, username: $username, email: $email, pass: $password, category: $category, title: $title}';
  }
}
