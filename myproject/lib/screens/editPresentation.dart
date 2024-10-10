import 'dart:convert';
import 'dart:io'; // For working with File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
// import 'package:myproject/screens/detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myproject/screens/addExample.dart';
// import 'package:myproject/screens/library_list.dart'; // Assuming this is the next screen
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:myproject/screens/installation_table.dart';

class MyData {
  String title;
  String description;
  String example;

  MyData({
    required this.title,
    required this.description,
    required this.example,
  });

  // Factory constructor to create an instance from JSON
  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      example: json['example'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'example': example,
    };
  }
}

class EditPresentation extends StatefulWidget {
  final VoidCallback onEdit;
  const EditPresentation(
      {super.key, required this.libraryId, required this.onEdit});
  final String libraryId;

  @override
  State<EditPresentation> createState() => _EditPresentationState();
}

class _EditPresentationState extends State<EditPresentation> {
  bool isLoading = true;
  List<dynamic> library = [];
  List<dynamic> INSTALLATION_DATA = [];
  List<dynamic> HOWTOUSE_DATA = [];
  List<dynamic> EXAMPLE_DES = [];
  List<dynamic> defaultFiles = [];
  List<String> removedFiles = [];

  final _libraryName = TextEditingController();
  final _description = TextEditingController();
  final _reference = TextEditingController();
  final _overviewDes = TextEditingController();
  final _installationDes = TextEditingController();
  final _howToUseDes = TextEditingController();
  final _exampleDes = TextEditingController();
  final _suggestionDes = TextEditingController();
  String _defaultImage = "";
  bool isEditing = false;

  File? _image; // Variable to hold the selected image
  List<File> _files = []; // Variable to hold the

  List<Map<String, String>> rowsInstallations = [];

  List<Map<String, String>> rowsHowToUse = [];

  List<Map<String, String>> rowsExample = [];

  @override
  void initState() {
    super.initState();
    fetchLibraryItems(); // Fetch data when the screen is initialized
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

  // Function to fetch data from the server
  Future<void> fetchLibraryItems() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    final url =
        Uri.parse('http://192.168.101.199:3001/getLibrary/${widget.libraryId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode JSON data
        List<dynamic> data = jsonDecode(response.body);        
        setState(() {
          // Set initial filtered list
          library = data;

          if (library.isNotEmpty) {
            _libraryName.text = library[0]["LIB_NAME"] ?? '';
            _description.text = library[0]["DESCRIPTION"] ?? '';
            _reference.text = library[0]["REFERENCE"] ?? '';
            _overviewDes.text = library[0]["DESCRIPTIONS_OVER"] ?? '';
            _installationDes.text = library[0]["DESCRIPTIONS_INS"] ?? '';
            _howToUseDes.text = library[0]["DESCRIPTIONS_HTU"] ?? '';
            _exampleDes.text = library[0]["DESCRIPTIONS_EXP"] ?? '';
            _suggestionDes.text = library[0]["DESCRIPTIONS_SGT"] ?? '';
            _defaultImage = library[0]["IMAGE"] ?? '';
            INSTALLATION_DATA = library[0]["INSTALLATION"] ?? [];
            HOWTOUSE_DATA = library[0]["HOWTOUSE"] ?? [];
            EXAMPLE_DES = library[0]["EXAMPLE"] ?? [];
            defaultFiles = library[0]["ATTRACHMENT"] ?? [];
          }
          if (INSTALLATION_DATA.isNotEmpty) {
            for (var i in INSTALLATION_DATA) {
              rowsInstallations.add({
                'title': i["title"],
                'description': i["description"],
                'example': i["example"]
              });
            }
          }

          if (HOWTOUSE_DATA.isNotEmpty) {
            for (var i in HOWTOUSE_DATA) {
              rowsHowToUse.add({
                'title': i["title"],
                'description': i["description"],
                'example': i["example"]
              });
            }
          }

          if (EXAMPLE_DES.isNotEmpty) {
            for (var i in EXAMPLE_DES) {
              rowsExample.add({
                'title': i["title"],
                'description': i["description"],
                'example': i["example"]
              });
            }
          }

          isLoading = false; // Set loading to false
        });
        
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  Future<void> uploadData() async {
    setState(() {
      isEditing = true;
    });
    // Create a map of data to send
    Map<String, dynamic> data = {
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
      'defaultImage': _defaultImage,
      'defaultFiles': defaultFiles,
      'removedFiles': removedFiles,
    };

    final uri = Uri.parse(
        'http://192.168.101.199:3001/mobile_update_library/${widget.libraryId}');
    final request = http.MultipartRequest('PUT', uri);
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
      widget.onEdit();
      // Navigator.pop(context);
    } else {
      print('Update failed with status: ${response.statusCode}');
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                        : Image.network(
                            'http://192.168.101.199:5173/server/src/uploads/$_defaultImage', // Replace with your image
                            width: 200,
                            height: 200,
                            // fit: BoxFit.cover,
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

                    // Displaying default files
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                      itemCount: defaultFiles.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: Text(
                            '${defaultFiles[index]['originalname']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          // Adding a delete icon to remove the file
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                removedFiles.add(defaultFiles[index]['originalname']);
                                defaultFiles.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    //display new files
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
                              setState(() {
                                _files.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),

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
                      child: isEditing 
                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth:2,
                                    color: Colors.white,
                                ), // Show progress indicator when downloading
                              )
                  :Text(
                        "Update",
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
    );
  }
}
