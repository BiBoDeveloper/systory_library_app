import 'dart:convert';
import 'dart:io'; // For working with File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:myproject/screens/library_list.dart'; // Assuming this is the next screen
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:myproject/screens/installation_table.dart';
import 'dialog_utils.dart';


class AddPresentation extends StatefulWidget {
  const AddPresentation({super.key});

  @override
  State<AddPresentation> createState() => _AddPresentationState();
}

class _AddPresentationState extends State<AddPresentation> {

  final _userName = TextEditingController();
  final _libraryName = TextEditingController();
  final _description = TextEditingController();
  final _reference = TextEditingController();
  final _overviewDes = TextEditingController();
  final _installationDes = TextEditingController();
  final _howToUseDes = TextEditingController();
  final _exampleDes = TextEditingController();
  final _suggestionDes = TextEditingController();
  File? _image; // Variable to hold the selected image


  List<Map<String, String>> rowsInstallations = [
    {'title' :'','description' : '','example' : ''},
  ];

  List<Map<String, String>> rowsHowToUse = [
    {'title' :'','description' : '','example' : ''},
  ];

  List<Map<String, String>> rowsExample = [
    {'title' :'','description' : '','example' : ''},
  ];

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

    rowsInstallations.removeLast();
    rowsHowToUse.removeLast();
    rowsExample.removeLast();
    // Create a map of data to send
    Map<String, dynamic> data = {
      'userName': _userName.text,
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

    final uri = Uri.parse('http://10.0.2.2:3000/mobile_addLibrary');
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

  void _addRow(String type,String title, String description, String example) {
    if (type == "installations") {
        setState(() {
        if (rowsInstallations.length == 1) {
          if (rowsInstallations[0]['title'] == "" && rowsInstallations[0]['description'] == "" && rowsInstallations[0]['example'] == "") {
            rowsInstallations.removeAt(0);
          }
          rowsInstallations.add({'title' : title, 'description' : description, 'example' : example });
          rowsInstallations.add({'title' : '', 'description' : '', 'example' : ''});
        }  else if (rowsInstallations.length > 1) {
          rowsInstallations.insert(rowsInstallations.length - 1,{'title' : title, 'description' : description, 'example' : example });
        } else {
          rowsInstallations.add({'title' : title, 'description' : description, 'example' : example });
          rowsInstallations.add({'title' : '', 'description' : '', 'example' : ''});
        }
      });
    } else if (type == "how_to_use") {
      setState(() {
        if (rowsHowToUse.length == 1) {
          if (rowsHowToUse[0]['title'] == "" && rowsHowToUse[0]['description'] == "" && rowsHowToUse[0]['example'] == "") {
            rowsHowToUse.removeAt(0);
          }
          rowsHowToUse.add({'title' : title, 'description' : description, 'example' : example });
          rowsHowToUse.add({'title' : '', 'description' : '', 'example' : '' });
        }  else if (rowsHowToUse.length > 1) {
          rowsHowToUse.insert(rowsHowToUse.length - 1,{'title' : title, 'description' : description, 'example' : example });
        } else {
          rowsHowToUse.add({'title' : title, 'description' : description, 'example' : example });
          rowsHowToUse.add({'title' : '', 'description' : '', 'example' : '' });
        }
      });
    } else if (type == "example") {
      setState(() {
        if (rowsExample.length == 1) {
          if (rowsExample[0]['title'] == "" && rowsExample[0]['description'] == "" && rowsExample[0]['example'] == "") {
            rowsExample.removeAt(0);
          }
          rowsExample.add({'title' : title, 'description' : description, 'example' : example });
          rowsExample.add({'title' : '', 'description' : '', 'example' : '' });
        }  else if (rowsExample.length > 1) {
          rowsExample.insert(rowsExample.length - 1,{'title' : title, 'description' : description, 'example' : example });
        } else {
          rowsExample.add({'title' : title, 'description' : description, 'example' : example });
          rowsExample.add({'title' : '', 'description' : '', 'example' : '' });
        }
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
              fontWeight: FontWeight.w600,
              color: Colors.white
            )
          ),
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

      //body
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Table

                const SizedBox(height: 10),

                // Use the separated table widget
                InstallationTable(
                  installationDes: rowsInstallations,
                  onRemoveRow: _removeRow,
                  type: 'installations',
                ),

                ElevatedButton(
                  onPressed: () {
                    showAddRowDialog(context, "installations", (title, description, example) {
                  _addRow("installations", title, description, example);
                });
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
                  controller: _howToUseDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Use the separated table widget
                InstallationTable(
                  installationDes: rowsHowToUse,
                  onRemoveRow: _removeRow,
                  type: 'how_to_use',
                ),

                ElevatedButton(
                  onPressed: () {
                    showAddRowDialog(context, "how_to_use", (title, description, example) {
                  _addRow("how_to_use", title, description, example);
                });
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
                  controller: _exampleDes,
                  decoration: const InputDecoration(
                    label: Text(
                      "Description",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Use the separated table widget
                InstallationTable(
                  installationDes: rowsExample,
                  onRemoveRow: _removeRow,
                  type: 'example',
                ),

                ElevatedButton(
                  onPressed: () {
                    showAddRowDialog(context, "example", (title, description, example) {
                  _addRow("example", title, description, example);
                });
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
                  onPressed: () {
                      uploadData();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (ctx) => const LibraryList()),
                      );
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
