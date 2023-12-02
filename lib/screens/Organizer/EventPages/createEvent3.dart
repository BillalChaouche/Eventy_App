import 'package:flutter/material.dart';
import 'package:eventy/widgets/circleStepRow.dart';
import 'package:eventy/widgets/toggleWidget.dart';
import 'package:eventy/widgets/personalizedButtonWidget.dart';
import 'package:eventy/widgets/appBar.dart';

class CreateEvent3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: "Create Event"),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            const CircleStepRow(step: 3),
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text("Other options:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF4F4F4F),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  toggleElement(context, "Show only to followers"),
                  const SizedBox(
                    height: 10,
                  ),
                  toggleElement(context, "Accept directly"),
                  const SizedBox(
                    height: 10,
                  ),
                  toggleElement(context, "Delete after the deadline"),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            PersonalizedButtonWidget(
                context: context, buttonText: "Finish", onClickListener: () {}),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }

  Container toggleElement(BuildContext context, String text) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 14.0, // Twice the radius to get the diameter
            height: 14.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF562525),
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          ToggleSwitch(),
        ],
      ),
    );
  }
}
