import 'package:flutter/material.dart';

class LikeTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Column for table headers
          Row(
            children: [
              TableHeaderCell('ID',
                  widthPercentage: 0.1, screenWidth: screenWidth),
              TableHeaderCell('USER',
                  widthPercentage: 0.28, screenWidth: screenWidth),
              TableHeaderCell('DATE',
                  widthPercentage: 0.16, screenWidth: screenWidth),
              TableHeaderCell('PRESENT',
                  widthPercentage: 0.18, screenWidth: screenWidth),
              TableHeaderCell('STATUS',
                  widthPercentage: 0.18, screenWidth: screenWidth),
            ],
          ),
          // Divider line
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 1.0,
            color: Colors.grey,
          ),
          // Column for table rows
          Column(
            children: [
              TableRowRow(
                id: 2,
                userName: 'Jhon wick',
                date: '12-13-22',
                presentStatus: 'Waiting',
                status: 'Accepted',
                screenWidth: screenWidth,
              ),
              const SizedBox(
                height: 10,
              ),
              TableRowRow(
                id: 2,
                userName: 'Jhon sick',
                date: '12-13-2022',
                presentStatus: 'Waiting',
                status: 'Accepted',
                screenWidth: screenWidth,
              ),
              const SizedBox(
                height: 10,
              ),
              TableRowRow(
                id: 2,
                userName: 'Jhon wick',
                date: '12-13-22',
                presentStatus: 'Waiting',
                status: 'Accepted',
                screenWidth: screenWidth,
              ),
            ],
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

  TableHeaderCell(this.title,
      {required this.widthPercentage, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * widthPercentage,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
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

  TableRowRow({
    required this.id,
    required this.userName,
    required this.date,
    required this.presentStatus,
    required this.status,
    required this.screenWidth,
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
              CircleAvatar(
                radius: 16.0,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    userName,
                    style: TextStyle(fontSize: 12),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          widthPercentage: 0.28,
          screenWidth: screenWidth,
        ),
        TableCellCell(date, widthPercentage: 0.16, screenWidth: screenWidth),
        TableCellCell(
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                presentStatus,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
          widthPercentage: 0.18,
          screenWidth: screenWidth,
        ),
        TableCellCell(
          Text(
            status,
            style: TextStyle(color: Colors.green, fontSize: 11),
          ),
          widthPercentage: 0.18,
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

  TableCellCell(this.content,
      {required this.widthPercentage, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * widthPercentage,
      padding: EdgeInsets.all(8.0),
      child: content is Widget
          ? content
          : Text(
              content.toString(),
              style: TextStyle(fontSize: 12),
            ),
    );
  }
}
