import 'dart:math';
import 'package:flutter/cupertino.dart';

class RandomPassword {
  bool lower;
  bool upper;
  bool character;
  bool number;
  double length;
  String pass = "";
  Map<String, String> value = {
    "lower": "abcdefghijklmnoprstuvwxyz",
    "upper": "ABCDEFGHIJKLMNOPRSTUVWXYZ",
    "number": "1234567890",
    "character": "!'^+%&/=?_*"
  };

  RandomPassword(
      {@required this.lower,
      @required this.upper,
      @required this.character,
      @required this.number,
      @required this.length}) {
    this.createPassword();
  }

  String createPassword() {
    List<String> key = [];
    if (lower) key.add("lower");
    if (upper) key.add("upper");
    if (character) key.add("character");
    if (number) key.add("number");
    for (int say = 0; say < length; say++) {
      String type = key[Random().nextInt(key.length)];
      pass += value[type][Random().nextInt(value[type].length)];
    }
    return pass;
  }
}
