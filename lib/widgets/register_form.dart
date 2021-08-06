import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/provider/auth_provider.dart';
import 'package:vendor/screen/home_screen.dart';


class RegisterForm extends StatefulWidget {


  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailEditingController = TextEditingController();
  var _passwordEditingController = TextEditingController();
  var _cPasswordEditingController = TextEditingController();
  var _addressEditingController = TextEditingController();
  var _nameEditingController = TextEditingController();
  var _dialogEditingController = TextEditingController();
  String email;
  String password;
  String shopName;
  String mobile;
  bool isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);//need to upload the path already we have it  done provider

    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('uploads/shopProfilePic,${_nameEditingController.text}').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.toString());
    }
    //now we get file url to save in the database
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic,${_nameEditingController.text}').getDownloadURL();
    return downloadURL;
  }
  @override
  Widget build(BuildContext context) {
    final _authDate = Provider.of<AuthProvider>(context);
    scaffoldmessage(message){
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),),);
    }
    return isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) : Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Your Business Name';
                  }
                  setState(() {
                    _nameEditingController.text = value;
                  });
                  setState(() {
                    shopName = value;
                  });
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add_business),
                  labelText: 'Business Name',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),//Name
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Mobile Number';
                  }
                  setState(() {
                    mobile = value;
                  });
                  return null;
                },
                decoration: InputDecoration(
                  prefixText: '91',
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Mobile Number',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.phone,
              ),
            ),//Number
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                controller: _emailEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Your Email';
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
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),//Email
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter to  password';
                  }
                  if(value.length < 6){
                    return 'Min of 6 character';
                  }
                  setState(() {
                    password = value;
                  });
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: ' Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),//Password
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Confirm password';
                  }
                  if(value.length < 6){
                    return 'Min of 6 character';
                  }
                  if(_passwordEditingController.text != _cPasswordEditingController.text){
                    return 'Password doesn\'t matching';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: 'Confirm Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),//Confirm Password
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                maxLines: 6,
                controller: _addressEditingController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Press the Navigator Button';
                  }if(_authDate.shopLatitude == null){
                    return 'Please Press the Navigator Button';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_searching),
                    onPressed: (){
                      _addressEditingController.text = 'Locating....\n Please Wait';
                      _authDate.getCurrentAddress().then((address){
                        if(address != null){
                          setState(() {
                            _addressEditingController.text = '${_authDate.placeName}\n${_authDate.shopAddress}';
                          });
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data'),),);
                        }
                      });
                    },

                  ),
                  prefixIcon: Icon(Icons.contact_mail_outlined),
                  labelText: 'Business Location',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),//Location
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextFormField(
                onChanged: (value){
                  _dialogEditingController.text = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.comment),
                  labelText: 'Shop dialog',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width:2.0,color: Theme.of(context).primaryColor,
                    ),
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),//Dialog
            SizedBox(height: 20.0,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                      onPressed: (){
                      if(_authDate.isPickAvail == true){//first will validate the pic
                        if (_formKey.currentState.validate()) {// then validate the form
                          setState(() {
                            isLoading = true;
                          });
                          _authDate.registerVendor(email, password).then((credential){
                            //user is registered
                            //now we will upload the profile pic to storage
                            if(credential != null){
                              uploadFile(_authDate.image.path).then((url){
                                if(url != null){
                                  //save vendor details to database
                                   _authDate.saveVendorDataToDb(
                                    url: url,
                                    shopName: shopName,
                                    mobile: mobile,
                                    dialog:  _dialogEditingController.text,
                                  );
                                    setState(() {
                                      _formKey.currentState.reset();
                                      isLoading = false;
                                    });
                                    Navigator.pushReplacementNamed(context, HomeScreen.id);

                                }else{
                                  scaffoldmessage('Failed to upload the ShopProfile pic');
                                }
                              });
                            }else{
                              //register failed
                              scaffoldmessage(_authDate.error);
                            }

                          });
                        }
                      }else{
                        scaffoldmessage('Shop Profile is need to be added');
                      }

                      },
                      child: Text('Register',style: TextStyle(color: Colors.white),)),
                ),
              ],
            )//Button
          ],
        )
    );
  }
}
