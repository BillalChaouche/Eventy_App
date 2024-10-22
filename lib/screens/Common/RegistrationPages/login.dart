import 'package:eventy/EndPoints/endpoints.dart';
import 'package:eventy/models/SharedData.dart';
import 'package:eventy/screens/Common/ChoicePages/User_Organization.dart';
import 'package:eventy/widgets/buildbutton_function.dart';
import 'package:eventy/widgets/buildemail_function.dart';
import 'package:eventy/widgets/buildpassword_function.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var rememberPassword = false;
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
                    'Login',
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
                  buildpasswordwidget('Password', _passwordController,
                      _passwordController, _formKey),

                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberPassword,
                              onChanged: (bool? value) {
                                setState(() {
                                  rememberPassword = value!;
                                });
                              },
                              activeColor: const Color(0x00662549),
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          16), // Add some spacing between checkbox and button
                  buildbutton(
                      text: 'Login',
                      functionallityButton: () async {
                        String enteredEmail = _emailController.text;
                        String enteredPassword = _passwordController.text;

                        print("Entered Email: $enteredEmail");
                        print("Entered Password: $enteredPassword");
                        Map<String, dynamic> userData = {
                          'email': enteredEmail,
                          'password': enteredPassword,
                        };
                        var userresponse = await userlogin(userData);
                        var organizerresponse = await organizerlogin(userData);
                        if (userresponse) {
                          SharedData.instance.sharedVariable = 'User';

                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        } else if (organizerresponse) {
                          SharedData.instance.sharedVariable = 'Organizer';
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        } else {

                          // Show SnackBar for unsuccessful login
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Login unsuccessful. Please check your credentials.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 30,
                  ),
                  // don't have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserOragnization(),
                              ));
                        },
                        child: Text(
                          'Sign up',
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
