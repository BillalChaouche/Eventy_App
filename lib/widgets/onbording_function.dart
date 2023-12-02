import 'package:animate_do/animate_do.dart';
import 'package:eventy/screens/Common/IntroPages/OnBording1.dart';
import 'package:eventy/screens/Common/IntroPages/OnBording2.dart';
import 'package:eventy/screens/Common/IntroPages/OnBording3.dart';
import 'package:eventy/screens/Common/RegistrationPages/login.dart';
import 'package:flutter/material.dart';

class OnBording extends StatefulWidget {
  const OnBording(
      {Key? key,
      required this.page_num,
      required this.title,
      required this.Image_Path})
      : super(key: key);
  final String title;
  final String Image_Path;
  final int page_num;

  @override
  _OnBordingState createState() => _OnBordingState();
}

class _OnBordingState extends State<OnBording> {
  Widget NextWidget(int num) {
    if (num == 1) {
      return OnBording2();
    } else {
      if (num == 2) {
        return OnBording3();
      }
    }
    return Login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 30),
            FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Image(
                  image: AssetImage(widget.Image_Path),
                  width: 250,
                  height: 450,
                  fit: BoxFit.cover,
                )),
            FadeInUp(
              duration: const Duration(milliseconds: 1000),
              delay: const Duration(milliseconds: 500),
              child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 45,
                    right: 20,
                    bottom: 25,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0x00662549).withOpacity(1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Color(0x00662549).withOpacity(0.3),
                          offset: Offset(0, -5),
                        )
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          delay: Duration(milliseconds: 1000),
                          from: 50,
                          child: Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            delay: Duration(milliseconds: 1000),
                            from: 60,
                            child: Text(
                              'Where Every Moment Finds Its Place',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              delay: Duration(milliseconds: 1000),
                              from: 70,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'SKIP',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            FadeInUp(
                              duration: Duration(milliseconds: 1000),
                              delay: Duration(milliseconds: 1000),
                              from: 70,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NextWidget((widget.page_num)),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'NEXT',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
