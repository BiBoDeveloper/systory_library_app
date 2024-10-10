import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/code_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

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
  Map<int, bool> isDownloading = {};

  @override
  void initState() {
    super.initState();
    fetchLibraryItems(); // Fetch data when the screen is initialized
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

  void downloadFile(String url, String fileName, int index) async {
    setState(() {
      isDownloading[index] = true; // Show the downloading icon
    });
  try {
    // Create a HttpClient instance
    HttpClient httpClient = HttpClient();

    // Create the request
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));

    // Send the request and get the response
    HttpClientResponse response = await request.close();

    // If the response status is successful (200)
    if (response.statusCode == 200) {
      // Get the directory for Android or iOS
      Directory? directory = await getPublicDirectory();
      if (directory != null) {
        String filePath = '${directory.path}/$fileName';

        // Create a file in the public directory (e.g., Downloads)
        File file = File(filePath);

        // Save the response as bytes and write it to the file
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        await file.writeAsBytes(bytes);        
      } else {
        // ignore: avoid_print
        print('Could not access public directory');
      }
    } else {
      // ignore: avoid_print
      print('Failed to download file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error downloading file: $e');
  } finally {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download $fileName successfully')),
    );
    setState(() {
        isDownloading[index] = false; // Switch back to the download icon
    });
  }
}

// Get the public directory where the file should be saved
Future<Directory?> getPublicDirectory() async {
  try {
    if (Platform.isAndroid) {
      // For Android, use the Downloads directory
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!(await directory.exists())) {
        directory.create(recursive: true);
      }
      return directory;
    } else if (Platform.isIOS) {
      // For iOS, get the Documents directory (which appears in the Files app)
      Directory directory = await getApplicationDocumentsDirectory();
      return directory;
    } else {
      return null;
    }
  } catch (e) {
    print('Error accessing public directory: $e');
    return null;
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
        setState(() {
          // Set initial filtered list
          library = data;
          isLoading = false; // Set loading to false
          for (int i = 0; i < library[0]['ATTRACHMENT'].length; i++) {
            isDownloading[i] = false; // Initially, nothing is downloading
          }
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
        backgroundColor: Colors.teal[800],
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: Colors.white,
            ),
            onSelected: (value) {
              FocusScope.of(context).unfocus();
              if (value == 'overview') {
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
                  },
                ),
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
                  },
                ),
                const SizedBox(height: 16),
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
                    return Container(
                      margin: const EdgeInsets.all(5),
                      // color: const Color.fromARGB(96, 173, 173, 173),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              items['filename'],
                          ),
                          GestureDetector(
                            onTap: () {
                              downloadFile(
                                  'http://192.168.101.199:5173/server/src/uploads/${items['filename']}', items['filename'], index);
                              
                            },
                            child: isDownloading[index]!
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth:2,
                                    color: Colors.black,
                                ), // Show progress indicator when downloading
                              )
                            : const Icon(
                                Icons.download
                              ),
                          ),
                          
                        ],
                        
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text("Reference",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['REFERENCE'] ?? ''}'),

                Text("Create by",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    )),
                SectionContent('${library[0]['name'] ?? ''}'),
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
