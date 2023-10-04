import 'package:demo/activities/DashboardScreen.dart';
import 'package:demo/activities/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //change screen
  changeScreen(){
    Future.delayed(const Duration(seconds: 2), () {
      //Get.to(() => SignInScreen());
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.offAll(() => LoginScreen());
        } else {
          Get.offAll(() => DashboardScreen());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/management.png', width: 100, height: 100, fit: BoxFit.cover),
      ),
    );
  }
}
