import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/homepage.dart';
import 'screens/haberpage.dart';
import 'screens/menu_screen.dart';
import 'screens/urundetay_espresso.dart';
import 'screens/rezervasyon.dart';
import 'screens/hesabım.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/adminpanel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:   SplashScreen(),//const  MyHomePage(title: 'Flutter Demo Ana Sayfa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final sayfalistesi=[
    CafeRestaurantInfo(),
    OffersPage(),
    MenuScreen(),
    ReservationPage(),
    ProfilePage()];
  int secilenindeks=0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: sayfalistesi[secilenindeks]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: secilenindeks,
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.brown[300],
        backgroundColor: const Color(0xFFE8DCCF),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            secilenindeks = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Hakkımızda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Kampanyalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Menü',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Rezervasyon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Hesabım',
          ),
        ],
      ),
    );
  }
}
