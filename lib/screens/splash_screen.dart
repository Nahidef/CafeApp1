import 'dart:async';
import 'package:cafeapp/main.dart';
import 'package:cafeapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cafeapp/screens/adminpanel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  _SplashscreenState createState() => _SplashscreenState();

}


class _SplashscreenState extends State<SplashScreen>{

    final FirebaseAuth _auth = FirebaseAuth.instance;

    @override
    void initState() {
      super.initState();
      Timer(Duration(seconds: 2), checkLoginStatus);
    }

    void checkLoginStatus() {
      User? user = _auth.currentUser;
      print('User email: ${user?.email}'); // Email'i konsola yazdır
      print('User verified: ${user?.emailVerified}'); // Email doğrulandı mı

      if (user != null) {
        if(user.email == "admin@gmail.com"){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=> const AdminPage()));
        }
        else{
        // Kullanıcı giriş yapmış
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> const MyHomePage(title: 'Cafe App')));
      }}
      else {
        // Giriş yapılmamış
         Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> const CafeRestaurantLogin()));
      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('resimler/ikon3.png',
          width: 120,
          height: 120,
        )
              ,
      ),
      backgroundColor: Color(0xFFB28355),
    );
  }
}


