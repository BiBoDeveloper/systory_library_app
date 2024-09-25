import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/library_list.dart';

class LibraryData {
  final int libId;
  final String libName;
  final String description;
  final String reference;
  final String descriptionsOver;
  final String descriptionsIns;
  final String descriptionsHtu;
  final String descriptionsExp;
  final String descriptionsSgt;
  final String image;
  final String createdBy;
  final List<Attachment> attachment;
  final List<Installation> installation;
  final List<HowToUse> howToUse;
  final List<Example> example;

  LibraryData({
    required this.libId,
    required this.libName,
    required this.description,
    required this.reference,
    required this.descriptionsOver,
    required this.descriptionsIns,
    required this.descriptionsHtu,
    required this.descriptionsExp,
    required this.descriptionsSgt,
    required this.image,
    required this.createdBy,
    required this.attachment,
    required this.installation,
    required this.howToUse,
    required this.example,
  });
}

class Attachment {
  final int size;
  final String filename;
  final String originalName;

  Attachment({
    required this.size,
    required this.filename,
    required this.originalName,
  });
}

class Installation {
  final int id;
  final String title;
  final String example;
  final String description;

  Installation({
    required this.id,
    required this.title,
    required this.example,
    required this.description,
  });
}

class HowToUse {
  final int id;
  final String title;
  final String example;
  final String description;

  HowToUse({
    required this.id,
    required this.title,
    required this.example,
    required this.description,
  });
}

class Example {
  final int id;
  final String title;
  final String example;
  final String description;

  Example({
    required this.id,
    required this.title,
    required this.example,
    required this.description,
  });
}
class Detail extends StatelessWidget {
  // final LibraryData libraryData;
  const Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Docker',
          style: GoogleFonts.kanit(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) => const LibraryList()));
          },
        ),
        backgroundColor: Colors.teal[800],
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
            onSelected: (value) {
              FocusScope.of(context).unfocus();
              if (value == 'edit') {
                // ignore: avoid_print
                // print('Edit selected for ${libraryItem.title}');
                // Navigate to edit page or show edit dialog
              } else if (value == 'delete') {
                // ignore: avoid_print
                // print('Delete selected for ${libraryItem.title}');
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text("Alert"),
                    content: const Text(
                        'Are you sure you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle delete action
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'overview',
                  child: Text('Overview'),
                ),
                const PopupMenuItem<String>(
                  value: 'installation',
                  child: Text('Installation'),
                ),
                const PopupMenuItem<String>(
                  value: 'howtouse',
                  child: Text('How To Use'),
                ),
                const PopupMenuItem<String>(
                  value: 'example',
                  child: Text('Example'),
                ),
                const PopupMenuItem<String>(
                  value: 'suggestion',
                  child: Text('Suggestion'),
                ),
              ];
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Image.network(
                  'http://192.168.101.199:5173/server/src/uploads/1726801030051-Docker-Symbol.png',
                  height: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Docker',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Text(
            "Overview",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            )
          ),
          const SectionContent(
              'Docker is a platform for developing, shipping, and running '
              'applications inside lightweight, portable containers. Initially '
              'developed by Solomon Hykes at DotCloud, it was open-sourced in 2013, '
              'allowing rapid adoption with its innovative containerization technology.'),
          const SizedBox(height: 16),
          Text(
            "Installation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            )
          ),
          const SectionContent(
              '1. Download Docker desktop from the official website: https://www.docker.com\n'
              '2. Run the installer and follow the instructions.\n'
              'Supported OS: Windows, macOS, Linux.'),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Command to check docker version
              },
              child: const Text('Check docker'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "How to use",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            )
          ),
          const SectionContent(
              'Docker simplifies the process of creating, deploying, and managing applications by using containers. '
              'Containers bundle everything needed to run, allowing for consistent performance across environments.'),
          Text(
            "Example",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            )
          ),
          const SectionContent(
              'Docker simplifies the process of creating, deploying, and managing applications by using containers. '
              'Containers bundle everything needed to run, allowing for consistent performance across environments.'),
          Text(
            "Suggestion",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            )
          ),
          const SectionContent(
              'Docker simplifies the process of creating, deploying, and managing applications by using containers. '
              'Containers bundle everything needed to run, allowing for consistent performance across environments.'),
        ],
      ),
    );
  }
}


class SectionContent extends StatelessWidget {
  final String content;

  const SectionContent(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      content,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    );
  }
}
