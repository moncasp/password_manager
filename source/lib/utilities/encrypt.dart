import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:simple_rc4/simple_rc4.dart';

class Encrypt {
  textEncrypt(String data, String key) async {
    var digest = md5.convert(Utf8Encoder().convert(key));
    String myKey = hex.encode(digest.bytes);
    RC4 rc4 = new RC4(myKey);
    var str = rc4.encodeString(data);
    return str;
  }

  textDecrypt(String encryptText, String key) async {
    var digest = md5.convert(Utf8Encoder().convert(key));
    String myKey = hex.encode(digest.bytes);
    RC4 rc4 = new RC4(myKey);
    var str = rc4.decodeString(encryptText);
    return str;
  }
}
