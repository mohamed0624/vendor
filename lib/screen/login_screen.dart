import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/provider/auth_provider.dart';
import 'package:vendor/screen/home_screen.dart';
import 'package:vendor/widgets/reset_page.dart';


class LoginScreen extends StatefulWidget {

  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  Icon icon;
  bool _visible = false ;
  String email;
  String password;
  var _emailEditingController = TextEditingController();
  bool _isLoading = false ;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SafeArea(
        child:Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child:
              Container(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LOGIN',style: TextStyle(fontFamily: 'Anton',fontSize: 50.0),),
                        Image.asset('assets/images/logo.png',height: 50,),
                      ],
                    ),
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
                    TextFormField(
                      validator: (value){
                        if(value.isEmpty){
                          return 'Enter your password';
                        }
                        if(value.length < 6){
                          return 'Min of 6 character';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: _visible == false ? true  :  false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: _visible ? Icon(Icons.visibility):Icon(Icons.visibility_off),
                            onPressed:(){
                              setState(() {
                                _visible = !_visible;
                              });
                            }),
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.vpn_key_outlined),
                        hintText: "Password",
                        labelText: 'Password',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width:2.0,color: Theme.of(context).primaryColor,
                          ),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, ResetPassword.id);
                            },
                            child: Text('Forgot Password',textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700),)),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                              color: Theme.of(context).primaryColor,
                            child: _isLoading ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.transparent,
                            ):Text("Login",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                              onPressed: (){
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  _isLoading = true;
                                });
                                auth.loginVendor(email, password).then((credential){
                                  if(credential != null){
                                    //if the users not null
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }else{
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error),),);
                                  }
                                });
                              }
                              },

                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
