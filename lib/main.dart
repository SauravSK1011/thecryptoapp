import 'package:cryptoapp/login.dart';
import 'package:cryptoapp/register.dart';
import 'package:cryptoapp/screens/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CryptoApp(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}

class CryptoApp extends StatefulWidget {
  CryptoApp({super.key});
 


  @override
  State<CryptoApp> createState() => _CryptoAppState();
}

class _CryptoAppState extends State<CryptoApp> {
  @override
  void initState() {
cheak();    super.initState();
  }
   bool isLogin = false;
  cheak() async {
      FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
setState(() {
  isLogin=true;
});

      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLogin? HomeScreen():MyLogin(),
    );
  }
}
