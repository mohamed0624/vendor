

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider with ChangeNotifier {

  File image;
  bool isPickAvail = false;
  String pickerError = '';
  String error ='';

  //vendor data
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;
  String email;
  String password;




  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 20);
    if(pickedFile != null){
      this.image = File(pickedFile.path);
      notifyListeners();
    }else{
      this.pickerError = 'No image is selected';
      print('No image is selected');
      notifyListeners();
    }
    return this.image;
  }

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    this.shopLatitude = _locationData.latitude;
    this.shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = new Coordinates(this.shopLatitude, this.shopLongitude);
    var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    this.placeName  = shopAddress.featureName;
    notifyListeners();
    return shopAddress;
  }

  Future<UserCredential> registerVendor(email,password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
       userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');

      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<UserCredential> loginVendor(email,password) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
       userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }


  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  //save to vendor data to Firestore

  Future<void> saveVendorDataToDb(
      {String url, String shopName, String mobile, String dialog}){
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendor = FirebaseFirestore.instance.collection('vendor').doc(user.uid);
    _vendor.set({
      'uid':user.uid,
      'imageUrl':url,
      'shopName':shopName,
      'mobile':mobile,
      'email':this.email,
      'dialog':dialog,
      'address' : '${this.placeName}:${this.shopAddress}',
      'location' : GeoPoint(this.shopLatitude,this.shopLongitude),
      'shopOpen' : true,//we will use later
      'rating':0.00,//later
      'totalRating':0.0,//later
      'isTopPicked':true,//later
      'accVerify':true,//only ver acc  r allowed

    });
    return null;
  }
}