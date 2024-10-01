import 'package:flutter/material.dart';
import 'package:myproject/screens/detail.dart';

class CodeBox extends StatelessWidget {
  final String title;
  final String description;
  final String code;
  const CodeBox(
      {super.key,
      required this.code,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 78, 78, 78),
            )),
        SectionContent(description),
        code != '' ? Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 49, 49, 49), // Set background color for the code box only
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header to display the code type
              const Text(
                'Code',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White color for the header
                ),
              ),
              const Divider(),
              const SizedBox(height: 10.0), // Add spacing between header and code
              // Code display area
              SizedBox(
                child: SingleChildScrollView(
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      fontFamily: 'monospace', // Monospace font for code
                      fontSize: 14.0,
                      color: Colors.grey, // Set code text color
                    ),
                  ),
                ),
              ),
            ],
          )
        ) 
        :
        const SizedBox(),
        const SizedBox(height: 10,)
      ],
    );
  }
}
