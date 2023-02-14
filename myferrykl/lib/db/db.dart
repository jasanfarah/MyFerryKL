import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:myferrykl/db/FerryTicket.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'User.dart';

class DBService {
  static final DBService instance = DBService._singletonConstructor();

  factory DBService() => instance;

  DBService._singletonConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'MyFerryKL.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: createTables,
    );
  }

  Future createTables(Database database, int version) async {
    await database.execute('''
 CREATE TABLE User (
      user_id INTEGER PRIMARY KEY,
      f_name VARCHAR(50) NOT NULL,
      l_name VARCHAR(50) NOT NULL,
      username VARCHAR(20) NOT NULL,
      password VARCHAR(20) NOT NULL,
      mobilehp VARCHAR(20) NOT NULL
  )
''');
    await database.rawInsert(
        'INSERT INTO User (user_id, f_name, l_name, username, password, mobilehp) VALUES (1, "John", "Doe", "johndoe", "password123", "123-456-7890")');

    await database.execute('''
 CREATE TABLE Ferryticket (
      book_id INTEGER PRIMARY KEY,
      depart_date DATE NOT NULL,
      journey VARCHAR(10) NOT NULL,
      depart_route VARCHAR(20) NOT NULL,
      dest_route VARCHAR(20) NOT NULL,
      user_id INTEGER NOT NULL
  )
''');
    await database.execute('''
    INSERT INTO Ferryticket (book_id, depart_date, journey, depart_route, dest_route, user_id)
VALUES (1, '2023-01-01', 'One Way', 'Kuala Lumpur', 'Copenhagen', 1);

     ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;

    await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Added user");
  }

  Future<void> insertFerryTicket(FerryTicket ferryTicket) async {
    final db = await database;

    await db.insert(
      'FerryTicket',
      ferryTicket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Added FerryTicket");
  }

  Future<bool> checkUserLogin(String username, String password) async {
    final db = await database;
    bool validLogin;

    List<Map> loginQuery = await db.query("User",
        columns: ["username", "password"],
        where: "username = ? and password = ?",
        whereArgs: [username, password]);
    if (loginQuery.length > 0) {
    validLogin =true;
    } else {
      validLogin = false;
    }
    return validLogin;
  }

  Future<String> GetUserID(String username, String password) async {
    final db = await database;
    var userQuery = await db.query("User",
        columns: ["user_id"],
        where: "username = ? and password = ?",
        whereArgs: [username, password]);

    String userid = userQuery.first.entries.first.value.toString();
    return userid ;
  }
  Future<List> findUserInfo(String user_id) async {
    final db = await database;

    List<Map> userInfo = await db.rawQuery(
        '''
      SELECT f_name,l_name,mobilehp FROM user where user_id = $user_id     '''
    );
    List<Map> ticketInfo = await findAllBookings(user_id);

    var userDataArray = [];
    for (int i = 0; i < userInfo.elementAt(0).length; i++) {
      userDataArray.add(userInfo.elementAt(0).entries.elementAt(i).value.toString());
    }
    for (int i = 0; i < ticketInfo.elementAt(0).length; i++) {
      userDataArray.add(ticketInfo.elementAt(0).entries.elementAt(i).value.toString());
    }


    return userDataArray;
  }

  Future<List<Map>> findAllBookings(String user_id) async {
    final db = await database;

    List<Map> ticket = await db.rawQuery(
     '''
     SELECT * FROM  ferryticket where user_id =( SELECT $user_id FROM User)
     '''
    );
    
    return ticket;
  }
  Future<List> findSpeceficBooking(String user_id,String bookingID) async {
    final db = await database;


    List<Map> userInfo = await db.rawQuery(
        '''
      SELECT f_name,l_name,mobilehp FROM user where user_id = $user_id     '''
    );

    List<Map> speceficTicketInfo = await db.rawQuery(
        '''
     SELECT * FROM  ferryticket where user_id =$user_id and book_id =$bookingID
     '''
    );

    var userDataArray = [];
    for (int i = 0; i < userInfo.elementAt(0).length; i++) {
      userDataArray.add(userInfo.elementAt(0).entries.elementAt(i).value.toString());
    }
    for (int i = 0; i < speceficTicketInfo.elementAt(0).length; i++) {
      userDataArray.add(speceficTicketInfo.elementAt(0).entries.elementAt(i).value.toString());
    }

    return userDataArray;
  }

  Future<List<Map>> deleteBooking(String user_id, String bookingID) async {
    final db = await database;

    List<Map> ticket = await db.rawQuery(
        '''
     DELETE FROM ferryticket where user_id =$user_id and book_id =$bookingID

     '''
    );

    return ticket;
  }

  Future<void> updateBooking(String user_id, String booking_id, String name,String surname,String phoneNr,String date, String departLocation,String destLocation,String journeyType) async {
    final db = await database;

    String userUpdateQuery = "UPDATE User SET f_name"+ "="+ "'"+name+"'"+","+ "l_name"+"="+"'"+surname+"'"+","+ "mobilehp"+"="+phoneNr+" WHERE user_id "+"="+ user_id;
var userUpdate = await db.rawQuery(userUpdateQuery);

String deleteTicketQuery = "DELETE FROM FerryTicket Where book_id = $booking_id ";
 var ticketDelete = await db.rawQuery(deleteTicketQuery);

 if(journeyType =="") {
   journeyType= "With return ticket";
 }
var SameTicket = new FerryTicket(
      bookId: int.parse(booking_id),
      departDate: DateTime.parse(date),
      journey: journeyType,
      departRoute: departLocation,
      destRoute: destLocation,
      userId: int.parse(user_id),
    );
insertFerryTicket(SameTicket);

   print("Updated succesfully!");
  }







  void testFerryTicket() {
    var ticket = new FerryTicket(
      bookId: Random.secure().nextInt(200),
      departDate: DateTime.now(),
      journey: 'One Way',
      departRoute: 'Kuala Lumpur',
      destRoute: 'Singapore',
      userId: 1,
    );
    final DBService db = DBService();

    db.insertFerryTicket(ticket);

  }


}