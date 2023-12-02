import 'package:eventy/widgets/onbording_function.dart';
import 'package:flutter/material.dart';

class OnBording1 extends StatefulWidget {
  const OnBording1({Key? key}) : super(key: key);

  @override
  _OnBording1State createState() => _OnBording1State();
}

class _OnBording1State extends State<OnBording1> {
  @override
  Widget build(BuildContext context) {
    return const OnBording(
      page_num: 1,
      title: 'Explore Upcoming And Nearby Events ',
      Image_Path: 'assets/images/onbording1.png',
    );
  }
}
