import 'package:flutter/material.dart';

void main() => runApp(const TableExampleApp());

class TableExampleApp extends StatelessWidget {
  const TableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Table Sample')),
        body: const TableExample(),
      ),
    );
  }
}

class TableExample extends StatefulWidget {
  const TableExample({super.key});

  @override
  _TableExampleState createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  // List of table rows data
  List<List<String>> tableData = [
    ['Javatpoint', 'Flutter', '5*'],
    ['Javatpoint', 'MySQL', '5*'],
    ['Javatpoint', 'ReactJS', '5*'],
  ];

  final TextEditingController websiteController = TextEditingController();
  final TextEditingController tutorialController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  // Method to remove a row at a given index
  void _removeRow(int index) {
    setState(() {
      tableData.removeAt(index); // Remove the row from the list
    });
  }

  // Method to add a new row
  void _addRow(String website, String tutorial, String review) {
    setState(() {
      tableData.add([website, tutorial, review]); // Add the new row to the list
    });
  }

  // Method to show dialog to add a new row
  void _showAddRowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Row"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: "Website"),
              ),
              TextField(
                controller: tutorialController,
                decoration: const InputDecoration(labelText: "Tutorial"),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: "Review"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: () {
                _addRow(
                  websiteController.text,
                  tutorialController.text,
                  reviewController.text,
                );
                // Clear the input fields and close the dialog
                websiteController.clear();
                tutorialController.clear();
                reviewController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(80.0),
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 2,
              ),
              children: [
                const TableRow(
                  children: [
                    Column(children: [Text('Website', style: TextStyle(fontSize: 20.0))]),
                    Column(children: [Text('Tutorial', style: TextStyle(fontSize: 20.0))]),
                    Column(children: [Text('Review', style: TextStyle(fontSize: 20.0))]),
                    SizedBox.shrink(), // Empty cell for the header row
                  ],
                ),
                // Dynamically create TableRow widgets based on tableData
                for (int i = 0; i < tableData.length; i++)
                  TableRow(
                    children: [
                      Column(children: [Text(tableData[i][0])]),
                      Column(children: [Text(tableData[i][1])]),
                      Column(children: [Text(tableData[i][2])]),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _removeRow(i); // Remove the row on button click
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _showAddRowDialog,
            child: const Text("Add New Row"),
          ),
        ],
      ),
    );
  }
}
