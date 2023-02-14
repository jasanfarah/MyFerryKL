import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:myferrykl/db/db.dart';
import 'package:sqflite/sqflite.dart';

class FerryTicket {
  final int bookId;
  final DateTime departDate;
  final String journey;
  final String departRoute;
  final String destRoute;
  final int userId;

  const FerryTicket({
    required this.bookId,
    required this.departDate,
    required this.journey,
    required this.departRoute,
    required this.destRoute,
    required this.userId,
  });
  Map<String, dynamic> toMap() {
    return {
      'book_id': bookId,
      'depart_date': departDate.toIso8601String(),
      'journey': journey,
      'depart_route': departRoute,
      'dest_route': destRoute,
      'user_id': userId,
    };
  }


}



