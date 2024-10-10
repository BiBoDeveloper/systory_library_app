import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddExample extends StatefulWidget {
  final Function onAddInstallation;
  const AddExample({super.key, required this.onAddInstallation});

  @override
  State<AddExample> createState() => _AddExampleState();
}

class _AddExampleState extends State<AddExample> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _example = TextEditingController();
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
                // Name Input Field
                const Text(
                  "Title",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: "Title",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF07837F),
                          width: 2), // Color when focused
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 6,
                  controller: _description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF07837F),
                          width: 2), // Color when focused
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Example",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  maxLines: 6,
                  controller: _example,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF07837F),
                          width: 2), // Color when focused
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data = {
                      'title': _title.text, 
                      'description': _description.text, 
                      'example': _example.text
                    };
                    widget.onAddInstallation(data);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF07837F)),
                  child: Text(
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
