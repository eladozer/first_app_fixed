import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

var key = "Key1986";

String xor_dec_enc(String text) {
  List<int> encrypted = [];
  for (int i = 0; i < text.length; i++) {
    int charCode = text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
    encrypted.add(charCode);
  }
  return String.fromCharCodes(encrypted);
}
