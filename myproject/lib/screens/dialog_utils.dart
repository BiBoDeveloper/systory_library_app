import 'package:flutter/material.dart';

// Function to show dialog based on type
void showAddRowDialog(BuildContext context, String type, Function(String, String, String) addRow) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController exampleController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add $type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: exampleController,
              decoration: const InputDecoration(labelText: "Example (code)"),
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
              // Call the callback function to add the row
              addRow(titleController.text, descriptionController.text, exampleController.text);
              titleController.clear();
              descriptionController.clear();
              exampleController.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
