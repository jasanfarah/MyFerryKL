import 'package:flutter/material.dart';
import 'package:myferrykl/bookingdetails.dart';
import 'package:myferrykl/db/db.dart';
import 'signin.dart';
import 'bookings.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _MyLoginForm();
}

class _MyLoginForm extends State<LoginForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loginerror = false;
    return Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(children: <Widget>[
          AppBar(
            title: Text('MyFerryKL',
                style: TextStyle(color: Colors.white, fontSize: 35)),
            backgroundColor: Colors.blue,
          ),
          Container(color: Colors.white,     height: 200.0,
              child: Image.asset('assets/logo.png')),
          Container(
              alignment: Alignment.center,
              child: const Text(
                'Please login to view your bookings',
                style: TextStyle(fontSize: 20),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(height: 10),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: handleLogin,
              )),
          Row(
            children: <Widget>[
              const Text('Does not have account?'),
              TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SigninForm()),
                    );
                  }),
            ],
          )
        ]));
  }

  Future<bool> handleLogin() async {
    final db = DBService();
    bool isLoginValid =
        await db.checkUserLogin(nameController.text, passwordController.text);

    if (isLoginValid == true) {
      String userID =
          await db.GetUserID(nameController.text, passwordController.text);
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Bookings(userID: userID)),
      );

      //TODO: Replace ViewBookingForm with the screen where you can manage bookings.
      return true;
    } else {
      print("Try again!");
      return false;
    }
  }
}
