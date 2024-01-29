import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventy/Providers/UserBookedProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikeTableWidget extends StatefulWidget {
  final int eventId;
  const LikeTableWidget({Key? key, required this.eventId}) : super(key: key);
  @override
  _LikeTableWidget createState() => _LikeTableWidget();
}

class _LikeTableWidget extends State<LikeTableWidget> {
  @override
  void initState() {
    super.initState();
    // You can fetch data or initialize here
    Provider.of<UserBookedProvider>(context, listen: false)
        .getUsers(widget.eventId);
    print(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 40, 16, 16),
      child: Column(
        children: [
          // Column for table headers
          Row(
            children: [
              TableHeaderCell('ID',
                  widthPercentage: 0.1, screenWidth: screenWidth),
              TableHeaderCell('USER',
                  widthPercentage: 0.40, screenWidth: screenWidth),
              TableHeaderCell('PRESENT',
                  widthPercentage: 0.2, screenWidth: screenWidth),
              TableHeaderCell('STATUS',
                  widthPercentage: 0.2, screenWidth: screenWidth),
            ],
          ),
          // Divider line
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            height: 1.0,
            color: Colors.grey,
          ),
          // Column for table rows
          Consumer<UserBookedProvider>(
            builder: (context, userBookedProvider, _) {
              if (userBookedProvider.usersBooked.isEmpty &&
                  userBookedProvider.noData) {
                return const Center(
                  child: Text('No data available'),
                );
              } else if (userBookedProvider.usersBooked.isEmpty &&
                  !userBookedProvider.noData) {
                return const SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF662549)),
                      strokeWidth: 2,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userBookedProvider.usersBooked.length,
                  itemBuilder: (context, index) {
                    final userBooked = userBookedProvider.usersBooked[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: TableRowRow(
                        id: userBooked.id,
                        userName: userBooked.name,
                        date: userBooked.date,
                        presentStatus: (userBooked.present == 1)
                            ? 'Done'
                            : 'waiting', // You can modify this based on your data
                        status:
                            (userBooked.accepted == 1) ? 'Accepted' : 'Accept',
                        screenWidth: screenWidth,
                        imageSrc: userBooked.image,
                        onTap: () {
                          userBookedProvider.acceptUser(userBooked.id);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class TableHeaderCell extends StatelessWidget {
  final String title;
  final double widthPercentage;
  final double screenWidth;

  const TableHeaderCell(this.title,
      {super.key, required this.widthPercentage, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * widthPercentage,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class TableRowRow extends StatelessWidget {
  final int id;
  final String userName;
  final String date;
  final String presentStatus;
  final String status;
  final double screenWidth;
  final String imageSrc;
  final VoidCallback? onTap;

  const TableRowRow({
    super.key,
    required this.id,
    required this.userName,
    required this.date,
    required this.presentStatus,
    required this.status,
    required this.screenWidth,
    required this.imageSrc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TableCellCell(id.toString(),
            widthPercentage: 0.1, screenWidth: screenWidth),
        TableCellCell(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: imageSrc ?? '', // Your image URL or null
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 16.0,
                  backgroundImage: imageProvider, // Set the image provider here
                ),
                placeholder: (context, url) => const CircleAvatar(
                  radius: 16.0,
                  backgroundColor: Colors.grey, // Placeholder color
                  // You can also set a placeholder icon or text here if needed
                ),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 16.0,
                  backgroundColor:
                      Colors.red, // Background color for error case
                  // You can set an error icon or text here to indicate image loading failure
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    userName,
                    style: const TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          widthPercentage: 0.4,
          screenWidth: screenWidth,
        ),
        TableCellCell(
          Container(
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
            decoration: BoxDecoration(
              color: (presentStatus == 'Done')
                  ? const Color.fromARGB(255, 152, 39, 79)
                  : Color.fromARGB(255, 241, 241, 241),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                presentStatus,
                style: TextStyle(
                    color: (presentStatus == 'Done')
                        ? Colors.white
                        : const Color.fromARGB(255, 152, 39, 79),
                    fontSize: 11),
              ),
            ),
          ),
          widthPercentage: 0.2,
          screenWidth: screenWidth,
        ),
        TableCellCell(
          TextButton(
            onPressed: () {
              if (status == "Accept") {
                onTap!();
              } else {
                return;
              }
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(
                    horizontal: 0, vertical: 2), // Adjust padding as needed
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius as needed
                ),
              ),
              backgroundColor: (status == "Accept")
                  ? MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 243, 243, 243))
                  : MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 114, 246, 107)), // Button color
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: (status == "Accept")
                      ? const Color.fromARGB(255, 114, 246, 107)
                      : const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 11),
            ),
          ),
          widthPercentage: 0.2,
          screenWidth: screenWidth,
        ),
      ],
    );
  }
}

class TableCellCell extends StatelessWidget {
  final dynamic content;
  final double widthPercentage;
  final double screenWidth;

  const TableCellCell(this.content,
      {super.key, required this.widthPercentage, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * widthPercentage,
      padding: const EdgeInsets.all(8.0),
      child: content is Widget
          ? content
          : Text(
              content.toString(),
              style: const TextStyle(fontSize: 11),
            ),
    );
  }
}
