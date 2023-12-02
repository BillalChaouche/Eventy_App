import 'package:eventy/widgets/onbording_function.dart';
import 'package:flutter/material.dart';

class OnBording2 extends StatefulWidget {
  const OnBording2({Key? key}) : super(key: key);

  @override
  _OnBording2State createState() => _OnBording2State();
}

class _OnBording2State extends State<OnBording2> {
  @override
  Widget build(BuildContext context) {
    return const OnBording(
      page_num: 2,
      title: 'Create your event and turn your vision into a reality.',
      Image_Path: 'assets/images/onbording2.png',
    );
  }
}
