import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor/screen/home_screen.dart';
import 'package:vendor/screen/login_screen.dart';
import 'package:vendor/screen/register_screen.dart';

class SplashScreen extends StatefulWidget {

  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
            (){
          FirebaseAuth.instance.authStateChanges().listen((User user) {
            if(user == null){
              Navigator.pushReplacementNamed(context, RegisterScreen.id);
            }else{
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
          });
        }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
                'Grocery Store - Vendor App',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }
}
