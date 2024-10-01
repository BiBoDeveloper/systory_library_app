import 'dart:convert';
import 'dart:io'; // For working with File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:myproject/screens/library_list.dart'; // Assuming this is the next screen
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddPresentation extends StatefulWidget {
  const AddPresentation({super.key});

  @override
  State<AddPresentation> createState() => _AddPresentationState();
}

class _AddPresentationState extends State<AddPresentation> {
  final _formKey = GlobalKey<FormState>();


  final String _userName = '';
  String _libraryName = '';
  String _description = '';
  String _reference = '';
  String _overviewDes = '';
  String _installationDes = '';
  String _howToUseDes = '';
  String _exampleDes = '';
  String _suggestionDes = '';
  final String _rowsInstallations = '';
  final String _rowsHowToUse = '';
  final String _rowsExample = '';
  File? _image; // Variable to hold the selected image

  List<List<String>> tableData = [
    ['', '', ''],
  ];

  List<List<String>> installationDes = [
    ['', '', ''],
  ];

  List<List<String>> rowsInstallations = [
    ['', '', ''],
  ];

  List<List<String>> rowsHowToUse = [
    ['', '', ''],
  ];

  List<List<String>> rowsExample = [
    ['', '', ''],
  ];

  //for installation description
  final TextEditingController installationDes_title = TextEditingController();
  final TextEditingController installationDes_Des = TextEditingController();
  final TextEditingController installationDes_Exam = TextEditingController();

  //for how to use
  final TextEditingController howToUse_title = TextEditingController();
  final TextEditingController howToUse_Des = TextEditingController();
  final TextEditingController howToUse_Exam = TextEditingController();
  
  //for example
  final TextEditingController example_title = TextEditingController();
  final TextEditingController example_Des = TextEditingController();
  final TextEditingController example_Exam = TextEditingController();
  
  // get http => null;

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

  Future<void> uploadData() async {
  print("-------GG-----------");

  // Create a map of data to send
  Map<String, dynamic> data = {
    'userName': _userName,
    'libraryName': _libraryName,
    'description': _description,
    'reference': _reference,
    'overviewDes': _overviewDes,
    'installationDes': _installationDes,
    'howToUseDes': _howToUseDes,
    'exampleDes': _exampleDes,
    'suggestionDes': _suggestionDes,
    'rowsInstallations': _rowsInstallations,
    'rowsHowToUse': _rowsHowToUse,
    'rowsExample': _rowsExample,
  };

  // final uri = Uri.parse('http://10.0.2.2:3000/addLibrary');
  final uri = Uri.parse('http://192.168.101.199:3001/addLibrary');
  final request = http.MultipartRequest('POST', uri);
  File? imageFile = _image;

  if (imageFile != null) {
    request.files.add(
      http.MultipartFile(
        'image',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: imageFile.path.split('/').last,
      ),
    );
  }

  // Add text fields data to the request as JSON
  request.fields['data'] = jsonEncode(data);

  // Send the request
  final response = await request.send();

  if (response.statusCode == 200) {
    final res = await http.Response.fromStream(response);
    final responseData = jsonDecode(res.body);
    print('Upload successful: $responseData');
  } else {
    print('Upload failed with status: ${response.statusCode}');
  }
}


  void _removeRow(String type, int index) {
    if (type == "installations") {
      setState(() {
        installationDes.removeAt(index); // Remove the row from the list
      });
    } else if (type == "how_to_use") {
      setState(() {
        installationDes.removeAt(index); // Remove the row from the list
      });
    } else if (type == "example") {
      setState(() {
        installationDes.removeAt(index); // Remove the row from the list
      });
    }
  }

  void _addRow(String type,String title, String description, String example) {
    if (type == "installations") {
        setState(() {
        if (installationDes.length == 1) {
          if (installationDes[0][0] == "" && installationDes[0][1] == "" && installationDes[0][2] == "") {
            installationDes.removeAt(0);
          }
          installationDes.add([title, description, example]);
          installationDes.add(['', '', '']);
        }  else if (installationDes.length > 1) {
          installationDes.insert(installationDes.length - 1,[title, description, example]);
        } else {
          installationDes.add([title, description, example]);
          installationDes.add(['', '', '']);
        }
      });
    } else if (type == "how_to_use") {
      setState(() {
        if (rowsHowToUse.length == 1) {
          if (rowsHowToUse[0][0] == "" && rowsHowToUse[0][1] == "" && rowsHowToUse[0][2] == "") {
            rowsHowToUse.removeAt(0);
          }
          rowsHowToUse.add([title, description, example]);
          rowsHowToUse.add(['', '', '']);
        }  else if (rowsHowToUse.length > 1) {
          rowsHowToUse.insert(rowsHowToUse.length - 1,[title, description, example]);
        } else {
          rowsHowToUse.add([title, description, example]);
          rowsHowToUse.add(['', '', '']);
        }
      });
    } else if (type == "example") {
      setState(() {
        if (rowsExample.length == 1) {
          if (rowsExample[0][0] == "" && rowsExample[0][1] == "" && rowsExample[0][2] == "") {
            rowsExample.removeAt(0);
          }
          rowsExample.add([title, description, example]);
          rowsExample.add(['', '', '']);
        }  else if (rowsExample.length > 1) {
          rowsExample.insert(rowsExample.length - 1,[title, description, example]);
        } else {
          rowsExample.add([title, description, example]);
          rowsExample.add(['', '', '']);
        }
      });
    }
  }


  void _showAddRowDialog(String type) {
    if (type == "installations") {
      // display the installations popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add installations"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: installationDes_title,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: installationDes_Des,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: installationDes_Exam,
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
                    "installations",
                    installationDes_title.text,
                    installationDes_Des.text,
                    installationDes_Exam.text,
                  );
                  // Clear the input fields and close the dialog
                  installationDes_title.clear();
                  installationDes_Des.clear();
                  installationDes_Exam.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (type == "how_to_use") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add how to use"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: howToUse_title,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: howToUse_Des,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: howToUse_Exam,
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
                    "how_to_use",
                    howToUse_title.text,
                    howToUse_Des.text,
                    howToUse_Exam.text,
                  );
                  // Clear the input fields and close the dialog
                  howToUse_title.clear();
                  howToUse_Des.clear();
                  howToUse_Exam.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (type == "example") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add example"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: example_title,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: example_Des,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: example_Exam,
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
                    "example",
                    example_title.text,
                    example_Des.text,
                    example_Exam.text,
                  );
                  // Clear the input fields and close the dialog
                  example_title.clear();
                  example_Des.clear();
                  example_Exam.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Systory Library',
          style: GoogleFonts.kanit(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        backgroundColor: const Color(0xFF07837F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LibraryList()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(
                16.0), // Optional: Add padding around the content
            children: [
              // Button to Pick Image
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF07837F)),
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
                    return "Please enter your Description";
                  }
                  return null;
                },
                onSaved: (value) {
                  _libraryName = value!;
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
                  _description = value!;
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
                  _reference = value!;
                },
              ),
              const SizedBox(height: 20),

              // Button to Pick a File
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF07837F)),
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
                  _overviewDes = value!;
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
                  _installationDes = value!;
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
                            child: Center(
                                child: Text('Title',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Description',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Example (Code)',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    for (int i = 0; i < installationDes.length; i++)
                      TableRow(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(installationDes[i][0], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(installationDes[i][1], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(installationDes[i][2], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 12.0,
                                onPressed: () {
                                  _removeRow("installations",i);
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
                onPressed: () {
                  _showAddRowDialog("installations");
                },
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
                  _howToUseDes = value!;
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
                            child: Center(
                                child: Text('Title',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Description',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Example (Code)',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    for (int i = 0; i < rowsHowToUse.length; i++)
                      TableRow(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsHowToUse[i][0], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsHowToUse[i][1], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsHowToUse[i][2], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 12.0,
                                onPressed: () {
                                  _removeRow("how_to_use",i);
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
                onPressed: () {
                  _showAddRowDialog("how_to_use");
                },
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
                  _exampleDes = value!;
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
                            child: Center(
                                child: Text('Title',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Description',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        Container(
                          color: Colors.cyan,
                          child: const SizedBox(
                            height: 30.0,
                            child: Center(
                                child: Text('Example (Code)',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.white))),
                          ),
                        ),
                        const SizedBox.shrink(),
                      ],
                    ),
                    for (int i = 0; i < rowsExample.length; i++)
                      TableRow(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsExample[i][0], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsExample[i][1], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                            child: SizedBox(
                              height: 30.0,
                              child: Center(child: Text(rowsExample[i][2], style: const TextStyle(fontSize: 12.0))),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                iconSize: 12.0,
                                onPressed: () {
                                  _removeRow("example",i);
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
                onPressed: () {
                  _showAddRowDialog("example");
                },
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
                  _suggestionDes = value!;
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    uploadData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => const LibraryList()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF07837F)),
                child: Text(
                  "Submit",
                  style: GoogleFonts.kanit(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
