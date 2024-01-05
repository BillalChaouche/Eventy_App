import 'package:eventy/models/SharedData.dart';
import 'package:eventy/screens/Common/RegistrationPages/signup_user.dart';
import 'package:eventy/widgets/buildbutton_function.dart';

import 'package:flutter/material.dart';

class UserOragnization extends StatefulWidget {
  const UserOragnization({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserOragnizationState createState() => _UserOragnizationState();
}

class _UserOragnizationState extends State<UserOragnization> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          // Image Row
          const Image(
            image: AssetImage('assets/images/logo.png'),
            width: 150,
            height: 150,
          ),
          // Text Row
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Sign Up as :',
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //     fontWeight: FontWeight.w700,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  const SizedBox(
                      height:
                          100), // Add some spacing between checkbox and button
                  buildbutton(
                      text: 'User',
                      functionallityButton: () async {
                        await SharedData.instance.saveSharedVariable('User');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpUser()),
                        );
                      }),
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await SharedData.instance.saveSharedVariable('Organizer');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpUser()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: const Color(0x662549).withOpacity(1),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 75, right: 75, top: 20, bottom: 20),
                    ),
                    child: Text(
                      'Organization',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0x662549).withOpacity(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Read more about : ',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
              GestureDetector(
                child: Text(
                  'Terms and Conditions',
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
    );
  }
}
