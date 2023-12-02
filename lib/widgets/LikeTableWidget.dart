import 'package:flutter/material.dart';

class LikeTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Column for table headers
          Row(
            children: [
              // Set the same flex values for the header
              Expanded(child: TableHeaderCell('ID', flex: 1)),
              Expanded(child: TableHeaderCell('USER', flex: 1)),
              Expanded(child: TableHeaderCell('DATE', flex: 1)),
              Expanded(child: TableHeaderCell('PRESENT', flex: 1)),
              Expanded(child: TableHeaderCell('STATUS', flex: 1)),
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
              // Row representing a table row
              TableRowRow(
                id: 2,
                userName: 'Jhon wick',
                date: '12-13-22',
                presentStatus: 'Waiting',
                status: 'Accepted',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TableHeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  TableHeaderCell(this.title, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex, // Set the provided flex value
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
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

  TableRowRow({
    required this.id,
    required this.userName,
    required this.date,
    required this.presentStatus,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Adjusted flex for ID column
        Expanded(child: TableCellCell(id.toString(), flex: 1)),
        Expanded(
          // Adjusted flex for USER column
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container for user with a row of round picture
              Container(
                child: CircleAvatar(
                  radius: 16.0,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              // Container for user name, allowing it to wrap to the next line
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
        ),
        // Adjusted flex for DATE column
        Expanded(child: TableCellCell(date, flex: 1)),
        // Adjusted flex for PRESENT column
        Expanded(
          child: TableCellCell(
            Container(
              padding: EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  presentStatus,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            flex: 1,
          ),
        ),
        // Adjusted flex for STATUS column
        Expanded(
          child: TableCellCell(
            Text(
              status,
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
            flex: 1,
          ),
        ),
      ],
    );
  }
}

class TableCellCell extends StatelessWidget {
  final dynamic content;
  final int flex; // Added flex property

  TableCellCell(this.content, {this.flex = 1}); // Default flex value to 1

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex, // Use the provided flex value
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: content is Widget
            ? content
            : Text(
                content.toString(),
                style: TextStyle(fontSize: 12),
              ),
      ),
    );
  }
}
