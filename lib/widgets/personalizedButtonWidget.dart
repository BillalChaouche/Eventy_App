import 'package:flutter/material.dart';

class PersonalizedButtonWidget extends StatelessWidget {
  const PersonalizedButtonWidget({
    super.key,
    required this.context,
    required this.buttonText,
    required this.onClickListener,
  });

  final BuildContext context;
  final String buttonText;
  final onClickListener;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          bottomLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        color: Color(0xFF662549),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: const Color(0xFFCE99A3), // Set the splash color here
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          onTap: onClickListener,
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
