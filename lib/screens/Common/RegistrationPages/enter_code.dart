import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/screens/Common/RegistrationPages/reset_password.dart';
import 'package:eventy/widgets/buildbox_function.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:flutter/material.dart';

class EnterCode extends StatefulWidget {
  const EnterCode({Key? key}) : super(key: key);

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  // Controllers for each box
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  bool isLoading = false;

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
                  'PassWord Reset',
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
                      buildboxwidget(controller: _controller1),
                      buildboxwidget(controller: _controller2),
                      buildboxwidget(controller: _controller3),
                      buildboxwidget(controller: _controller4),
                    ],
                  )),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                        strokeWidth: 2,
                      )
                    : buildbutton(
                        text: 'Enter code',
                        functionallityButton: () async {
                          setState(() {
                            isLoading = true;
                          });
                          // Read entered numbers and form the verification code
                          String email = SharedData.instance.email;
                          String verificationCode = _controller1.text +
                              _controller2.text +
                              _controller3.text +
                              _controller4.text;
                          print('Sending  code: $verificationCode');
                          var response =
                              await verifycode(email, verificationCode);
                          setState(() {
                            isLoading = false;
                          });
                          // Call the function to send verification email with the code
                          if (response) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetPassword(),
                                ));
                          } else {
                            // Show SnackBar for unsuccessful verification
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Verification code is incorrect. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
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
