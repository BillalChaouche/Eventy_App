import 'package:eventy/screens/User/CategoryPages/CategoryPage.dart';
import 'package:flutter/material.dart';
import 'package:eventy/widgets/blurButton.dart';
import 'package:ionicons/ionicons.dart';

class CategoryWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isLike;

  const CategoryWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.isLike,
  }) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.isLike;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryPage(
                    categoryName: widget.title,
                  )),
        )
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 227, 227, 227).withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                blurButton(
                    icon: (isLiked) ? Ionicons.heart : Ionicons.heart_outline,
                    width: 30,
                    height: 30,
                    iconSize: 14,
                    color: const Color.fromARGB(255, 227, 185, 185),
                    functionallityButton: () {
                      isLiked = !isLiked;
                      setState(() {
                        isLiked;
                      });
                    })
              ],
            ),
            Container(
              width: 47,
              height: 47,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 102, 37, 73),
                // Replace with your desired color
                borderRadius: BorderRadius.circular(75), // Make it a circle
              ),
              child: Center(
                child: Icon(
                  widget.icon, // Replace with your desired icon
                  size: 24, // Adjust the size of the icon
                  color: Colors.white, // Change the icon color if needed
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
