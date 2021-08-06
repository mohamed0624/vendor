import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/provider/auth_provider.dart';
import 'package:vendor/screen/login_screen.dart';


class ResetPassword extends StatefulWidget {
  static const String id = 'reset_password';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {


  String email;
  var _emailEditingController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child:
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png',height: 90,),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(text: "Forgot your password",style: TextStyle(color: Colors.red,fontSize: 21.0,fontWeight: FontWeight.w700)),
                        TextSpan(text: "\nDon't worry provide us your registered email id we will send email to your id to reset ur password ",
                            style: TextStyle(color: Colors.black,fontSize: 18.0)),
                      ]
                    ),),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailEditingController,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter your email';
                        }
                        final bool isValid = EmailValidator.validate(_emailEditingController.text);
                        if(!isValid){
                          return 'Invalid Email Format';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                        labelText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width:2.0,color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              color:Theme.of(context).primaryColor,
                              onPressed: (){
                                if(_formKey.currentState.validate()){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  auth.resetPassword(email);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check email'),),);
                                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                                }
                              },
                              child: _isLoading ? LinearProgressIndicator():Text('RESET PASSWORD',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)),
                        ),
                      ],
                    )
                  ],
                ),
              ),

          ),
        ),

    );
  }
}
