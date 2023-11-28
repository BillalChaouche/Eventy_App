import 'package:eventy/Components/BottomNavbar.dart';
import 'package:eventy/Components/PageAppBar.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:eventy/widgets/categoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    Map<int, List<dynamic>> categories = {
      1: ['Sport', Ionicons.baseball, false],
      2: ['Education', Ionicons.book, true],
      3: ['Music', Ionicons.musical_notes, true],
      4: ['Art', Ionicons.aperture, false],
    };
    return Scaffold(
        extendBody: true,
        appBar: PageAppBar(
            title: 'Categories', context: context, backButton: false),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            20,
            18,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate((categories.length / 3).ceil(), (index) {
              int startIndex = index * 3;
              int endIndex = (startIndex + 3 < categories.length)
                  ? startIndex + 3
                  : categories.length;

              List<Widget> categoryRow = [];

              for (int i = startIndex; i < endIndex; i++) {
                categoryRow.add(
                  CategoryWidget(
                    title: categories[i + 1]![0],
                    icon: categories[i + 1]![1],
                    isLike: categories[i + 1]![2],
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: categoryRow,
              );
            }).toList(),
          ),
        )),
        bottomNavigationBar: BottomNavbar(
          currentIndex: 3,
          navigatorContext: context,
        ));
  }
}
