import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/screens/Common/RegistrationPages/enter_code.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:eventy/widgets/buildemail_function.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
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
                    'Password Reset',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildemailwidget(_emailController),

                  const SizedBox(height: 16),
                  isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                          strokeWidth: 2,
                        )
                      : // Add some spacing between checkbox and button
                      buildbutton(
                          text: 'Enter',
                          functionallityButton: () async {
                            setState(() {
                              isLoading = true;
                            });
                            String enteredEmail = _emailController.text;

                            print("Entered Email: $enteredEmail");

                            SharedData.instance.email = enteredEmail;
                            sendcode(enteredEmail);
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EnterCode(),
                                ));
                          }),
                  const SizedBox(
                    height: 30,
                  ),
                  // don't have an account
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
