import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/provider/auth_provider.dart';
import 'package:vendor/screen/home_screen.dart';
import 'package:vendor/screen/login_screen.dart';
import 'package:vendor/screen/register_screen.dart';
import 'package:vendor/screen/splash_screen.dart';
import 'package:vendor/widgets/reset_page.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(

    MultiProvider(
        providers:[
         Provider(create: (_)=>AuthProvider()),
        ],
      child: MyApp(),

    ),

  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xff84c225),
            fontFamily: 'Lato'
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id : (context) =>SplashScreen(),
          RegisterScreen.id : (context) =>RegisterScreen(),
          HomeScreen.id : (context) => HomeScreen(),
          LoginScreen.id : (context) => LoginScreen(),
          ResetPassword.id : (context) => ResetPassword(),
        }
    );
  }
}
