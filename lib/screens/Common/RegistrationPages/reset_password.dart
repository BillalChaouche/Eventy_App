// ignore_for_file: use_build_context_synchronously

import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:eventy/widgets/buildpassword_function.dart';
import 'package:eventy/screens/Common/RegistrationPages/login.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
                  isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                          strokeWidth: 2,
                        )
                      : buildbutton(
                          text: 'Reset Password',
                          functionallityButton: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, process the data
                              String enteredPassword = _passwordController.text;
                              print("Entered Password: $enteredPassword");
                              String email = SharedData.instance.email;

                              Map<String, dynamic> userData = {
                                'email': email,
                                'password': enteredPassword,
                              };
                              await resetpassword(userData);
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            }
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
                            color: const Color(0x00662549).withOpacity(1),
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
