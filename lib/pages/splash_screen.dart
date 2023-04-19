import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/app_consts.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  sendToNexScreenAfterSomeTime(Duration afterTime) {
    Future.delayed(afterTime, () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sendToNexScreenAfterSomeTime(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              Column(
                children: [
                  MyConst.appDisplayName.text.xl5.bold.white.make().shimmer(primaryColor: Vx.purple300, secondaryColor: Colors.white),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      MyConst.appTagLineText,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black45),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              const CircularProgressIndicator(color: Vx.purple300),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
