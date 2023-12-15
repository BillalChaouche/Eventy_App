import 'package:animate_do/animate_do.dart';
import 'package:eventy/RootPage.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/screens/Common/IntroPages/OnBording1.dart';
import 'package:eventy/screens/Common/RegistrationPages/email_verification.dart';
import 'package:eventy/screens/User/HomePages/Home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () async {
      int logged_user = await DBUserOrganizer.getAllCount();
      if (logged_user > 0) {
        print("there is a user already logged in");
        List userData = await DBUserOrganizer.getUser();
        print(userData[0]);
        if (userData[0]['verified'] == 1) {
          print("this user is verified");
          Navigator.pushNamed(context, '/');
        } else {
          print("this user is not verified");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => EmailVerification()));
        }
      } else {
        print("no user is logged in");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => OnBording1()));
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ))),
    );
  }
}
