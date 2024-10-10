import 'dart:convert';
import 'dart:io'; // For working with File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:localstorage/localstorage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/screens/addExample.dart';

import 'package:myproject/screens/installation_table.dart';

class AddPresentation extends StatefulWidget {
  final VoidCallback onAddPresentation;
  const AddPresentation({super.key, required this.onAddPresentation});

  @override
  State<AddPresentation> createState() => _AddPresentationState();
}

class _AddPresentationState extends State<AddPresentation> {
  final _libraryName = TextEditingController();
  final _description = TextEditingController();
  final _reference = TextEditingController();
  final _overviewDes = TextEditingController();
  final _installationDes = TextEditingController();
  final _howToUseDes = TextEditingController();
  final _exampleDes = TextEditingController();
  final _suggestionDes = TextEditingController();
  File? _image; // Variable to hold the selected image
  bool isAdding = false;
  List<File> _files = [];

  List<Map<String, String>> rowsInstallations = [];

  List<Map<String, String>> rowsHowToUse = [];

  List<Map<String, String>> rowsExample = [];

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  // Method to pick files from file app
  Future<void> _pickFile() async {
    FilePickerResult? pickedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (pickedFiles != null) {
      List<File> files = pickedFiles.paths.map((path) => File(path!)).toList();
      setState(() {
        _files = files;
      });
    } else {
      print('No files selected');
    }
  }

  Future<void> uploadData() async {
    // Create a map of data to send
    setState(() {
      isAdding = true;
    });
    Map<String, dynamic> data = {
      'userName': localStorage.getItem('userId'),
      'libraryName': _libraryName.text,
      'description': _description.text,
      'reference': _reference.text,
      'overviewDes': _overviewDes.text,
      'installationDes': _installationDes.text,
      'HowToUseDes': _howToUseDes.text,
      'exampleDes': _exampleDes.text,
      'suggestionDes': _suggestionDes.text,
      'rowsInstallations': rowsInstallations,
      'rowsHowToUse': rowsHowToUse,
      'rowsExample': rowsExample,
    };

    final uri = Uri.parse('http://192.168.101.199:3001/mobile_addLibrary');
    // final uri = Uri.parse('http://192.168.101.199:3001/addLibrary');
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

    if (_files.length > 0) {
      for (var file in _files) {
        request.files.add(
          http.MultipartFile(
            'files',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ),
        );
      }
    }

    // Add text fields data to the request as JSON
    request.fields['data'] = jsonEncode(data);

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      widget.onAddPresentation();
      Navigator.pop(context);
    } else {
      showDialog<String>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Alert"),
          content: Text('Upload failed with status: ${response.statusCode}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      isAdding = true;
    });
  }

  // Add this method to handle file removal
  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _removeRow(String type, int index) {
    if (type == "installations") {
      setState(() {
        rowsInstallations.removeAt(index); // Remove the row from the list
      });
    } else if (type == "how_to_use") {
      setState(() {
        rowsHowToUse.removeAt(index); // Remove the row from the list
      });
    } else if (type == "example") {
      setState(() {
        rowsExample.removeAt(index); // Remove the row from the list
      });
    }
  }

  void _editRow(String type, String title, String description, String example,int index) {
    if (type == "installations") {
      // ignore: avoid_print
      print('Edited Row: $title, $description, $example, $index');
      setState(() {
        rowsInstallations[index] =
            ({'title': title, 'description': description, 'example': example});
      });
    } else if (type == "how_to_use") {
      setState(() {
        rowsHowToUse[index] =
            ({'title': title, 'description': description, 'example': example});
      });
    } else if (type == "example") {
      setState(() {
        rowsExample[index] =
            ({'title': title, 'description': description, 'example': example});
      });
    }
  }

  void _addRow(String type, String title, String description, String example) {
    if (type == "installations") {
      setState(() {
        rowsInstallations.add(
            {'title': title, 'description': description, 'example': example});
      });
    } else if (type == "how_to_use") {
      setState(() {
        rowsHowToUse.add(
            {'title': title, 'description': description, 'example': example});
      });
    } else if (type == "example") {
      setState(() {
        rowsExample.add(
            {'title': title, 'description': description, 'example': example});
      });
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
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
      ),

      //body
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Button to Pick Image
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07837F)),
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
                    : const Text(
                        "No image selected",
                        style: TextStyle(color: Colors.grey),
                      ),
                const SizedBox(height: 50),

                // Name Input Field
                TextFormField(
                  controller: _libraryName,
                  decoration: const InputDecoration(
                    label: Text(
                      "Library Name",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Input Field
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Reference Input Field
                TextFormField(
                  controller: _reference,
                  decoration: const InputDecoration(
                    label: Text(
                      "Reference",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Button to Pick a File
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07837F)),
                  child: const Text(
                    "Upload File",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                // Show the list of selected files
                if (_files.isNotEmpty) ...[
                  const Text(
                    'Selected Files:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Displaying the selected files
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                    itemCount: _files.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(
                          _files[index].path.split('/').last,
                          style: const TextStyle(fontSize: 14),
                        ),
                        // Adding a delete icon to remove the file
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeFile(index);
                          },
                        ),
                      );
                    },
                  ),
                ] else ...[
                  const Text(
                    'No files selected',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],

                const SizedBox(height: 10),

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
                  controller: _overviewDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
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
                  controller: _installationDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Section for Table Installations
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Table installations',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // Table

                const SizedBox(height: 10),

                // Use the separated table widget
                rowsInstallations.isNotEmpty
                    ? InstallationTable(
                        installationDes: rowsInstallations,
                        onRemoveRow: _removeRow,
                        onEditRow: _editRow,
                        type: 'installations',
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "No data available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => AddExample(
                                  onAddInstallation: (value) {
                                    _addRow("installations", value['title'],
                                        value['description'], value['example']);
                                    // print(value['title']);
                                  },
                                )));
                  },
                  child: const Text("Add New Row",
                      style: TextStyle(fontSize: 16.0)),
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
                  controller: _howToUseDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Table how to use',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                // Use the separated table widget
                rowsHowToUse.isNotEmpty
                    ? InstallationTable(
                        installationDes: rowsHowToUse,
                        onRemoveRow: _removeRow,
                        onEditRow: _editRow,
                        type: 'how_to_use',
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "No data available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => AddExample(
                                  onAddInstallation: (value) {
                                    _addRow("how_to_use", value['title'],
                                        value['description'], value['example']);
                                    // print(value['title']);
                                  },
                                )));
                  },
                  child: const Text("Add New Row",
                      style: TextStyle(fontSize: 16.0)),
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
                  controller: _exampleDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Table example',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                // Use the separated table widget
                rowsExample.isNotEmpty
                    ? InstallationTable(
                        installationDes: rowsExample,
                        onRemoveRow: _removeRow,
                        onEditRow: _editRow,
                        type: 'example',
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "No data available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => AddExample(
                                  onAddInstallation: (value) {
                                    _addRow("example", value['title'],
                                        value['description'], value['example']);
                                    // print(value['title']);
                                  },
                                )));
                  },
                  child: const Text("Add New Row",
                      style: TextStyle(fontSize: 16.0)),
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
                  controller: _suggestionDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    await uploadData();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07837F)),
                  child: isAdding 
                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth:2,
                                    color: Colors.white,
                                ), // Show progress indicator when downloading
                              )
                  : Text(
                    "Submit",
                    style: GoogleFonts.kanit(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
