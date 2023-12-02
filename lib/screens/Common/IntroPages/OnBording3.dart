import 'package:eventy/widgets/onbording_function.dart';
import 'package:flutter/material.dart';

class OnBording3 extends StatefulWidget {
  const OnBording3({Key? key}) : super(key: key);

  @override
  _OnBording3State createState() => _OnBording3State();
}

class _OnBording3State extends State<OnBording3> {
  @override
  Widget build(BuildContext context) {
    return const OnBording(
        page_num: 3,
        title: 'Book your event from the comfort of your home',
        Image_Path: 'assets/images/onbording3.png');
  }
}
