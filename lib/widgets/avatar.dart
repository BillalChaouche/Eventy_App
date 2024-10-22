import 'package:flutter/material.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color(0x662549).withOpacity(1),
                  width: 2,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/images/profile.jpg",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Youcef Amari",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Icon(Icons.edit),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                  side: BorderSide(
                    color: Color(0x662549).withOpacity(1), // Border color
                    width: 2.0, // Border width
                  ),
                ),
              ),
              child: Text("Following",
                  style: TextStyle(
                    color: Color(0x662549).withOpacity(1),
                  ))),
        ],
      ),
    );
  }
}
