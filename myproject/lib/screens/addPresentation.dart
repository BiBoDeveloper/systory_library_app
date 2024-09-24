import 'dart:io'; // For working with File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:myproject/screens/item.dart'; // Assuming this is the next screen

class AddPresentation extends StatefulWidget {
  const AddPresentation({super.key});

  @override
  State<AddPresentation> createState() => _AddPresentationState();
}

class _AddPresentationState extends State<AddPresentation> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _age = 20;
  File? _image; // Variable to hold the selected image

  List<List<String>> tableData = [
    ['', '', ''],
  ];

  final TextEditingController websiteController = TextEditingController();
  final TextEditingController tutorialController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  void _removeRow(int index) {
    setState(() {
      tableData.removeAt(index); // Remove the row from the list
    });
  }

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

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Systory Library'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
  key: _formKey,
  child: ListView(
    padding: const EdgeInsets.all(16.0), // Optional: Add padding around the content
    children: [
      // Button to Pick Image
      ElevatedButton(
        onPressed: _pickImage,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text(
          "Upload Image",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      const SizedBox(height: 20),
      // Display the selected image
      _image != null
          ? Image.file(
              _image!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            )
          : const Text("No image selected"),
      const SizedBox(height: 50),
      
      // Name Input Field
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Library Name",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your name";
          }
          return null;
        },
        onSaved: (value) {
          _name = value!;
        },
      ),
      const SizedBox(height: 20),
      
      // Description Input Field
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),
      
      // Reference Input Field
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Reference",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Reference";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),
      
      // Button to Pick a File
      ElevatedButton(
        onPressed: _pickImage,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text(
          "Upload File",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      const SizedBox(height: 20),
      
      // Section for Overview
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      
      // Description under Overview
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),
      
      // Section for Installation
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Installation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      
      // Description under Installation
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),
      
      // Section for Table Installations
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Table installations',
          style: TextStyle(fontSize: 16),
        ),
      ),
      // Table
      Container(
        margin: const EdgeInsets.all(5),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(90.0), 
          columnWidths: const {
            0: FixedColumnWidth(90.0),
            1: FixedColumnWidth(130.0),
            2: FixedColumnWidth(100.0),
            3: FixedColumnWidth(30.0),
          },
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0,
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
                const SizedBox.shrink(),
              ],
            ),
            for (int i = 0; i < tableData.length; i++)
              TableRow(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][0], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][1], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][2], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 12.0,
                        onPressed: () {
                          _removeRow(i);
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
        child: const Text("Add New Row", style: TextStyle(fontSize: 16.0)),
      ),

      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'How to use',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Description under Installation
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),


      Container(
        margin: const EdgeInsets.all(5),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(90.0), 
          columnWidths: const {
            0: FixedColumnWidth(90.0),
            1: FixedColumnWidth(130.0),
            2: FixedColumnWidth(100.0),
            3: FixedColumnWidth(30.0),
          },
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0,
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
                const SizedBox.shrink(),
              ],
            ),
            for (int i = 0; i < tableData.length; i++)
              TableRow(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][0], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][1], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][2], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 12.0,
                        onPressed: () {
                          _removeRow(i);
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
        child: const Text("Add New Row", style: TextStyle(fontSize: 16.0)),
      ),

      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Example',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      
      // Description under Installation
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),

      Container(
        margin: const EdgeInsets.all(5),
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(90.0), 
          columnWidths: const {
            0: FixedColumnWidth(90.0),
            1: FixedColumnWidth(130.0),
            2: FixedColumnWidth(100.0),
            3: FixedColumnWidth(30.0),
          },
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.cyan,
                  child: const SizedBox(
                    height: 30.0,
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
                const SizedBox.shrink(),
              ],
            ),
            for (int i = 0; i < tableData.length; i++)
              TableRow(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][0], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][1], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                    ),
                    child: SizedBox(
                      height: 30.0,
                      child: Center(child: Text(tableData[i][2], style: const TextStyle(fontSize: 12.0))),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 12.0,
                        onPressed: () {
                          _removeRow(i);
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
        child: const Text("Add New Row", style: TextStyle(fontSize: 12.0)),
      ),

      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Suggestion',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      
      // Description under Installation
      TextFormField(
        decoration: const InputDecoration(
          label: Text(
            "Description",
            style: TextStyle(fontSize: 16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your Description";
          }
          return null;
        },
        onSaved: (value) {
          _age = int.tryParse(value.toString()) ?? 0;
        },
      ),
      const SizedBox(height: 20),

      
      // Submit Button
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => const Item()),
            );
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 20),
        ),
      ),
    ],
  ),
),

      ),
    );
  }
}