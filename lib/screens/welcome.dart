import 'package:flutter/material.dart';
import 'package:garagesalesv/screens/itemlist.dart';
import '../components/button.dart';
import 'registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'itemlist.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _auth = FirebaseAuth.instance;
  String warning = '';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String userPassword;
  String userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Silicon Valley',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 14.0,
              ),
              Text(
                'GARAGE SALE',
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
                textAlign: TextAlign.center,
              ),
              Text(warning, textAlign: TextAlign.center),
              SizedBox(
                height: 14.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (key) {
                  userEmail = key;
                },
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Your Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
              ),
              SizedBox(
                height: 14.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (key) {
                  userPassword = key;
                },
                decoration: InputDecoration(
                  hintText: 'Your Password',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 14.0,
              ),
              MyButton(
                title: 'LOGIN',
                color: Colors.orange,
                onPressed: () async {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: userEmail, password: userPassword);
                    if (user != null) {
                      print('logged in');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList()));
                    }
                  } catch (e) {
                    setState(() {
                      warning ='Username or password not right, please check';
                    });
                    print(e);
                  }
                },
              ),

              MyButton(
                title: 'SIGN-UP',
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
                },
              ),
            ],
          ),
        ),
      );
   }
}


