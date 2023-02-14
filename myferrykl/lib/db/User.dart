import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:myferrykl/db/db.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final int? userId;
  final String fName;
  final String lName;
  final String username;
  final String password;
  final String mobile;

  const User({
    required this.userId,
    required this.fName,
    required this.lName,
    required this.username,
    required this.password,
    required this.mobile});

  String get _username => username;
  String get _password => password;
  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'f_name': fName,
      'l_name': lName,
      'username': username,
      'password': password,
      'mobilehp': mobile
    };
  }


  // Extract a User object from a Map object
  String toJson() => json.encode(toMap());
}
