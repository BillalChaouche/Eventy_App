import 'package:eventy/widgets/buildbox_function.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        // Image Row

        const Image(
          image: AssetImage('assets/images/logo.png'),
          width: 150,
          height: 150,
        ),

        // Text Row
        Form(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Email Verification',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildboxwidget(),
                      buildboxwidget(),
                      buildboxwidget(),
                      buildboxwidget(),
                    ],
                  )),
                ),
                const SizedBox(
                    height: 20), // Add some spacing between checkbox and button
                buildbutton(
                    text: 'Continue',
                    functionallityButton: () {
                      Navigator.pushNamed(context, '/');
                    }),
                const SizedBox(
                  height: 30,
                ),
                // don't have an account
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chech your email for verification',
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
