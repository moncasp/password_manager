import 'dart:async';

import 'package:flutter/material.dart';
import 'package:password_manager/database/db_helper.dart';
import 'package:password_manager/database/db_model.dart';
import 'package:password_manager/pages/add_page.dart';
import 'package:password_manager/utilities/encrypt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isload = true;
  DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _allPass;

  TextEditingController _controller = TextEditingController();
  Encrypt _encrypt = Encrypt();
  Completer<void> _refleshComplater = Completer<void>();

  Future<String> validationKey(BuildContext context) async {
    String ssd;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Şifreleme keyini giriniz"),
            content: TextField(
              autofocus: true,
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

  showInfo(DBModel _model, String openPass) async {
    TextEditingController mypasscontroller = TextEditingController();
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Column(
            children: [
              AlertDialog(
                title: Text(
                  _model.title,
                ),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("username :"),
                        Text(_model.username),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("email :"),
                        Text(_model.email),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: mypasscontroller..text = openPass,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  getir() {
    isload = true;
    _dbHelper.listPass().then((value) {
      _allPass = value;
      isload = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allPass = [];
    getir();
  }

  @override
  Widget build(BuildContext context) {
    _refleshComplater.complete();
    _refleshComplater = Completer();
    return RefreshIndicator(
      onRefresh: () {
        getir();
        return _refleshComplater.future;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Password Manager",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: [
              FlatButton(
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AddPage()))
                      .then((value) => getir());
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: isload
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: _allPass.length,
                            itemBuilder: (context, index) {
                              DBModel _dbmodel =
                                  DBModel.fromMap(_allPass[index]);
                              return Card(
                                elevation: 3,
                                child: ListTile(
                                  onLongPress: () async {
                                    String verify =
                                        await validationKey(context);
                                    if (verify != null) {
                                      String openPass =
                                          await _encrypt.textDecrypt(
                                              _dbmodel.password, verify);
                                      DBModel editmodel = _dbmodel;
                                      editmodel.password = openPass;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddPage(model: editmodel),
                                        ),
                                      ).then((value) => getir());
                                    }
                                  },
                                  title: Text(_dbmodel.title),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_dbmodel.username),
                                      Text(_dbmodel.email),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.vpn_key),
                                    onPressed: () async {
                                      String verify =
                                          await validationKey(context);
                                      if (verify != null) {
                                        try {
                                          String openPass =
                                          await _encrypt.textDecrypt(
                                              _dbmodel.password, verify);
                                          await showInfo(_dbmodel, openPass);
                                        }catch(e){
                                          print(e);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
