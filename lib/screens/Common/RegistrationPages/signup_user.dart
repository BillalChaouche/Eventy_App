import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/databases/DBUserOrganizer.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:eventy/widgets/buildemail_function.dart';
import 'package:eventy/widgets/buildpassword_function.dart';
import 'package:eventy/widgets/buildusername_function.dart';
import 'package:eventy/screens/Common/RegistrationPages/login.dart';
import 'package:eventy/screens/Common/RegistrationPages/email_verification.dart';
import 'package:flutter/material.dart';

class SignUpUser extends StatefulWidget {
  const SignUpUser({Key? key}) : super(key: key);

  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
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
            key: _formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SignUp',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  buildusernamewidget(_usernameController),
                  buildemailwidget(_emailController),
                  buildpasswordwidget('Password', _passwordController,
                      _confirmPasswordController, _formKey),
                  buildpasswordwidget(
                      'Confirm password',
                      _confirmPasswordController,
                      _passwordController,
                      _formKey),
                  const SizedBox(
                      height:
                          30), // Add some spacing between checkbox and button
                  buildbutton(
                    text: 'SignUp',
                    functionallityButton: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, process the data
                        String enteredEmail = _emailController.text;
                        String enteredPassword = _passwordController.text;
                        String enteredUsername = _usernameController.text;

                        print("Entered Username: $enteredUsername");
                        print("Entered Email: $enteredEmail");
                        print("Entered Password: $enteredPassword");
                        print(
                            "sign up as: ${await SharedData.instance.getSharedVariable()}");
                        Map<String, dynamic> userData = {
                          'name': enteredUsername,
                          'email': enteredEmail,
                          'password': enteredPassword,
                        };
                        if (await SharedData.instance.getSharedVariable() ==
                            "User") {
                          userSignup(userData);
                        } else {
                          organizerSignup(userData);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmailVerification()),
                        );
                      }
                      ;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already registred? ',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0x662549).withOpacity(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
