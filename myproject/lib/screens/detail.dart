import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/code_box.dart';
import 'package:myproject/screens/library_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> downloadFile(String url, String filename) async {
  try {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String savePath = '${appDocDir.path}/$filename';

    await Dio().download(url, savePath);
    print('File downloaded to $savePath');
  } catch (e) {
    print('Error downloading file: $e');
  }
}

class DownloadLink extends StatelessWidget {
  final String fileName;
  final String fileUrl;

  const DownloadLink(
      {super.key, required this.fileName, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await downloadFile(fileUrl, fileName);
        // Optionally, show a message or open the file
      },
      child: Text(
        fileName,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

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

class Detail extends StatefulWidget {
  final String libraryId;
  const Detail({super.key, required this.libraryId});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isLoading = true;
  List<dynamic> library = [];
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _installationKey = GlobalKey();
  final GlobalKey _howToUseKey = GlobalKey();
  final GlobalKey _exampleKey = GlobalKey();
  final GlobalKey _suggestionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchLibraryItems(); // Fetch data when the screen is initialized
    // print('Filtered item count: ${filteredLibraryItems.length}');
  }

  // Function to scroll to the specific section
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500), // Smooth scroll animation
        alignment: 0.1,
      );
    }
  }

  // Function to fetch data from the server
  Future<void> fetchLibraryItems() async {
    // print('id:::::> $libraryId')
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
        // ignore: avoid_print
        print('response=====> $data');
        setState(() {
          // Set initial filtered list
          library = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${library[0]['LIB_NAME']}',
          style: GoogleFonts.kanit(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
                // Handle edit action
              } else if (value == 'delete') {
                // Handle delete action
              } else if (value == 'overview') {
                _scrollToSection(_overviewKey); // Scroll to Overview section
              } else if (value == 'installation') {
                _scrollToSection(
                    _installationKey); // Scroll to Installation section
              } else if (value == 'howtouse') {
                _scrollToSection(_howToUseKey); // Scroll to How to Use section
              } else if (value == 'example') {
                _scrollToSection(_exampleKey); // Scroll to Example section
              } else if (value == 'suggestion') {
                _scrollToSection(
                    _suggestionKey); // Scroll to Suggestion section
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.network(
                        'http://192.168.101.199:5173/server/src/uploads/${library[0]['IMAGE']}',
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${library[0]['LIB_NAME']}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Text("Overview",
                    key: _overviewKey, // Assign GlobalKey
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['DESCRIPTION'] ?? ''}'),
                const SizedBox(height: 16),
                Text("Installation",
                    key: _installationKey, // Assign GlobalKey
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['DESCRIPTIONS_INS'] ?? ''}'),
                ListView.builder(
                  shrinkWrap:
                      true, // Ensures that the inner ListView takes only as much space as needed
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                  itemCount: library[0]['INSTALLATION'].length,
                  itemBuilder: (context, index) {
                    var items = library[0]['INSTALLATION'][index];
                    return CodeBox(
                        code: items['example'],
                        title: items['title'],
                        description: items['description']);
                    // return Text(items['title']);
                  },
                ),
                const SizedBox(height: 16),
                Text("How to use",
                    key: _howToUseKey, // Assign GlobalKey
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['DESCRIPTIONS_HTU'] ?? ''}'),
                ListView.builder(
                  shrinkWrap:
                      true, // Ensures that the inner ListView takes only as much space as needed
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                  itemCount: library[0]['HOWTOUSE'].length,
                  itemBuilder: (context, index) {
                    var items = library[0]['HOWTOUSE'][index];
                    return CodeBox(
                        code: items['example'],
                        title: items['title'],
                        description: items['description']);
                    // return Text(items['title']);
                  },
                ),
                Text("Example",
                    key: _exampleKey, // Assign GlobalKey
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['DESCRIPTIONS_HTU'] ?? ''}'),
                ListView.builder(
                  shrinkWrap:
                      true, // Ensures that the inner ListView takes only as much space as needed
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                  itemCount: library[0]['EXAMPLE'].length,
                  itemBuilder: (context, index) {
                    var items = library[0]['EXAMPLE'][index];
                    return CodeBox(
                        code: items['example'],
                        title: items['title'],
                        description: items['description']);
                    // return Text(items['title']);
                  },
                ),
                Text("Suggestion",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['DESCRIPTIONS_SGT'] ?? ''}'),
                const SizedBox(height: 16),
                Text("Attachments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                ListView.builder(
                  shrinkWrap:
                      true, // Ensures that the inner ListView takes only as much space as needed
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
                  itemCount: library[0]['ATTRACHMENT'].length,
                  itemBuilder: (context, index) {
                    var items = library[0]['ATTRACHMENT'][index];
                    return DownloadLink(
                      fileName: items['filename'],
                      fileUrl:
                          'http://192.168.101.199:5173/server/src/uploads/${items['filename']}',
                    );
                    // return Text(items['title']);
                  },
                ),
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
