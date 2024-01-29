import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class CircleStepRow extends StatelessWidget {
  const CircleStepRow({
    super.key,
    required this.step,
  });

  final int step;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circleStep('1', step == 1),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: const DottedLine(),
        ),
        circleStep('2', step == 2),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: const DottedLine(),
        ),
        circleStep('3', step == 3)
      ],
    );
  }

  DottedLine lineBetween() {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: Colors.black,
      dashGradient: const [Color(0xFF662549), Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      dashGapGradient: const [Color(0xFF662549), Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Container circleStep(String num, bool selected) {
    return Container(
      width: 40, // Set the diameter of the circle
      height: 40, // Set the diameter of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF662549), // Border color #662549
          width: 2, // Border width
        ),
      ),
      child: CircleAvatar(
        backgroundColor: selected ? const Color(0xFF662549) : Colors.transparent,
        child: Text(
          num,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF662549),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
