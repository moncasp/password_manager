import 'package:flutter/material.dart';
import 'package:password_manager/database/db_helper.dart';
import 'package:password_manager/database/db_model.dart';
import 'package:password_manager/utilities/encrypt.dart';
import 'package:password_manager/utilities/random_password_generate.dart';

// ignore: must_be_immutable
class AddPage extends StatefulWidget {
  DBModel model;
  AddPage({this.model});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool lower = true;
  bool upper = true;
  bool number = true;
  bool character = true;
  double length = 12.0;
  String _title;
  String _username;
  String _email;
  String _password;
  Encrypt _encrypt = Encrypt();
  TextEditingController _controller = TextEditingController();
  TextEditingController mycontroller = TextEditingController();
  final mykey = GlobalKey<FormState>();
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    if (widget.model != null) mycontroller.text = widget.model.password;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.model == null ? "Add New Password" : "Edit Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            autovalidate: true,
            key: mykey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        widget.model == null ? "" : widget.model.title,
                    onSaved: (data) {
                      _title = data.toString();
                    },
                    validator: (data) {
                      if (data.length < 4)
                        return "Title en az 4 karakter olmalı";
                      return null;
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.title),
                        labelText: "Title",
                        hintText: ""),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        widget.model == null ? "" : widget.model.username,
                    onSaved: (data) {
                      _username = data.toString();
                    },
                    validator: (data) {
                      if (data.length < 1) return null;
                      if (data.length < 4)
                        return "Username en az 4 karakter olmalı";
                      return null;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Username",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue:
                        widget.model == null ? "" : widget.model.email,
                    onSaved: (data) {
                      _email = data.toString();
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (data) {
                      if (data.length < 1) return null;
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(data);
                      if (emailValid) {
                        return null;
                      }
                      return "geçersiz mail adresi";
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail_outline),
                      labelText: "E-Mail",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (data) {
                      _password = data.toString();
                    },
                    controller: mycontroller,
                    validator: (String data) {
                      if (data.length < 1) return null;
                      if (data.length < 8)
                        return "şifre en az 8 karakter uzunluğunda olmalıdır";
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cached),
                          onPressed: () {
                            var randPass = RandomPassword(
                                lower: lower,
                                upper: upper,
                                character: character,
                                number: number,
                                length: length);
                            mycontroller.text = randPass.pass;
                          },
                        )),
                  ),
                ),
                SizedBox(
                  height: 15,
                  width: 200,
                ),
                ButtonBar(
                  children: [
                    Visibility(
                      visible: widget.model == null ? true : false,
                      child: FlatButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        onPressed: () {
                          if (mykey.currentState.validate()) {
                            mykey.currentState.save();
                            validationKey(context).then((value) async {
                              if (value != null) {
                                _password = await _encrypt.textEncrypt(
                                    _password, value);
                                DBModel _model = DBModel(
                                    username: _username,
                                    email: _email,
                                    password: _password,
                                    title: _title,
                                    category: "undefined");
                                try {
                                  _dbHelper.addPass(_model).then((int value) =>
                                      {print("basarılı " + value.toString())});
                                } catch (e) {
                                  print("db error");
                                }
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: widget.model != null ? true : false,
                      child: FlatButton(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        onPressed: () {
                          if (mykey.currentState.validate()) {
                            mykey.currentState.save();
                            validationKey(context).then((value) async {
                              if (value != null) {
                                _password = await _encrypt.textEncrypt(
                                    _password, value);
                                DBModel _model = DBModel.withID(
                                    id: widget.model.id,
                                    username: _username,
                                    email: _email,
                                    password: _password,
                                    title: _title,
                                    category: "undefined");
                                try {
                                  _dbHelper.updatePass(_model).then(
                                      (int value) =>
                                          {print("basarılı  " + value.toString())});
                                } catch (e) {
                                  print("db error");
                                }
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: widget.model != null ? true : false,
                      child: FlatButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color:  Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        onPressed: () {
                          try {
                            _dbHelper.deletePass(widget.model.id).then(
                                (int value) =>
                                    {print("basarılı " + value.toString())});
                          } catch (e) {
                            print("db error");
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  child: Divider(
                    color: Colors.red,
                    height: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          "Random Password Content",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SwitchListTile(
                          title: Text(
                            "lower case",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("abcdefghijklmnoprstuvwxyz"),
                          value: lower,
                          onChanged: (data) {
                            lower = data;
                            setState(() {});
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "uppercase letter",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("ABCDEFGHIJKLMNOPRSTUVWXYZ"),
                          value: upper,
                          onChanged: (data) {
                            upper = data;
                            setState(() {});
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Number",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("1234567890"),
                          value: number,
                          onChanged: (data) {
                            number = data;
                            setState(() {});
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            "Characters",
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text("!'^+%&/=?_*"),
                          value: character,
                          onChanged: (data) {
                            character = data;
                            setState(() {});
                          },
                        ),
                        Text("Password length"),
                        Slider(
                          min: 8,
                          max: 20,
                          value: length,
                          divisions: 12,
                          onChanged: (data) {
                            length = data;
                            setState(() {});
                          },
                          label: "$length",
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> validationKey(BuildContext context) async {
    String ssd;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Şifreleme keyini giriniz"),
            content: TextField(
              controller: _controller,
            ),
            actions: [
              FlatButton(
                child: Text("Onayla"),
                onPressed: () {
                  ssd = _controller.text;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("iptal"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    return Future.value(ssd);
  }
}

