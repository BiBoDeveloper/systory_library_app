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
    ['', '', ''],
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
      if (tableData.length == 1) {
        if (tableData[0][0] == "" && tableData[0][1] == "" && tableData[0][2] == "") {
          tableData.removeAt(0);
        }
        tableData.add([website, tutorial, review]);
        tableData.add(['', '', '']);
      }  else if (tableData.length > 1) {
        tableData.insert(tableData.length - 1,[website, tutorial, review]);
      } else {
        tableData.add([website, tutorial, review]);
        tableData.add(['', '', '']);
      }
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
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: tutorialController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: reviewController,
                decoration: const InputDecoration(labelText: "Example(code)"),
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
        margin: const EdgeInsets.all(5),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(90.0), // Default column width set to 90
          // border: TableBorder.all(
          //   color: Colors.black,
          //   style: BorderStyle.solid,
          //   width: 0.1,
          // ),
          columnWidths: const {
            0: FixedColumnWidth(90.0), // Column 1 (Title) width
            1: FixedColumnWidth(150.0), // Column 2 (Description) width
            2: FixedColumnWidth(100.0), // Column 3 (Example) width
            3: FixedColumnWidth(30.0),  // Column 4 (Icon) width
          },
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0, // Row height for header
                    child: Center(child: Text('Title', style: TextStyle(fontSize: 12.0, color: Colors.white))),
                  ),
                ),
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0,
                    child: Center(child: Text('Description', style: TextStyle(fontSize: 12.0, color: Colors.white))),
                  ),
                ),
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0,
                    child: Center(child: Text('Example (Code)', style: TextStyle(fontSize: 12.0, color: Colors.white))),
                  ),
                ),
                const SizedBox.shrink(), // Empty header for the icon column
              ],
            ),
            // Dynamically create TableRow widgets based on tableData
            for (int i = 0; i < tableData.length; i++)
              TableRow(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 0.1), // Left border
                        top: BorderSide(color: Colors.black, width: 0.1),  // Top border
                        bottom: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                        right: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                      ),
                    ),
                    child: SizedBox(
                      height: 30.0, // Row height for content
                      child: Center(child: Text(tableData[i][0], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 0.1), // Left border
                        top: BorderSide(color: Colors.black, width: 0.1),  // Top border
                        bottom: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                        right: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                      ),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][1], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black, width: 0.1), // Left border
                        top: BorderSide(color: Colors.black, width: 0.1),  // Top border
                        bottom: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                        right: BorderSide(color: Colors.black, width: 0.1), // Bottom border
                      ),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][2], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  SizedBox(
                    height: 30.0, // Adjust the height of the icon column
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 16.0,
                        onPressed: () {
                          _removeRow(i); // Remove the row on button click
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      ElevatedButton(
        onPressed: _showAddRowDialog,
        child: const Text("Add New Row", style: TextStyle(fontSize: 12.0)), // Consistent text size
      ),
    ],
  ),
);

  }
}
