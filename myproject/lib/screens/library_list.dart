import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:myproject/models/person.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/screens/addPresentation.dart';
import 'package:myproject/screens/detail.dart';
// import 'package:myproject/screens/addform.dart';
// import 'package:myproject/screens/loginPage.dart';

class LibraryList extends StatefulWidget {
  const LibraryList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LibraryListState createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {
  // List of library items
  // final List<LibraryItem> allLibraryItems = List.generate(
  //   5,
  //   (index) => LibraryItem(
  //     title: 'Langchain',
  //     description:
  //         'Docker is a tool that is used to automate the deployment of application',
  //     author: 'pele',
  //   ),
  // );
  List<LibraryItem> allLibraryItems = [];

  // Filtered list for the search functionality
  List<LibraryItem> filteredLibraryItems = [];
  bool isLoading = true; // Initial loading state

  @override
  void initState() {
    super.initState();
    fetchLibraryItems(); // Fetch data when the screen is initialized
    // print('Filtered item count: ${filteredLibraryItems.length}');
  }

  // Function to fetch data from the server
  Future<void> fetchLibraryItems() async {
    setState(() {
      isLoading = true; // Set loading to true
    });
    final url = Uri.parse('http://192.168.101.199:3001/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Decode JSON data
        List<dynamic> data = jsonDecode(response.body);
        // ignore: avoid_print
        print(data);

        // Map the JSON to the LibraryItem model
        List<LibraryItem> fetchedItems = data.map((item) {
          return LibraryItem(
            title: item['LIB_NAME'],
            description: item['DESCRIPTION'],
            author: item['CREATE_BY'],
            image: item['IMAGE'],
            id: item['LIB_ID'].toString(),
          );
        }).toList();

        setState(() {
          allLibraryItems = fetchedItems;
          filteredLibraryItems = allLibraryItems; // Set initial filtered list
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

  void _filterLibraryList(String query) {
    // If the search query is empty, show all items
    if (query.isEmpty) {
      setState(() {
        filteredLibraryItems = allLibraryItems;
      });
    } else {
      setState(() {
        filteredLibraryItems = allLibraryItems
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF07837F),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset(
                    'assets/images/systory_logo.png', // Replace with your image
                    width: 35,
                    height: 35,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('SYSTORY LIBRARY',
                  style: GoogleFonts.kanit(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white))),
            ],
          ),
        ),
        actions: const [
          Icon(
            Icons.logout,
            color: Colors.black,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                onChanged:
                    _filterLibraryList, // Calls function when input changes
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('Library list',
                      style: GoogleFonts.kanit(textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                      ),
                ],
              ),
              // const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator()) // Loading indicator
                    : ListView.builder(
                        itemCount: filteredLibraryItems.length,
                        itemBuilder: (context, index) {
                          return LibraryItemCard(
                              libraryItem: filteredLibraryItems[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle button press for adding a new library item
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (ctx) => const AddPresentation())
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LibraryItem {
  final String title;
  final String description;
  final String author;
  final String image;
  final String id;

  LibraryItem({
    required this.title,
    required this.description,
    required this.author,
    required this.image,
    required this.id,
  });
}

class LibraryItemCard extends StatelessWidget {
  final LibraryItem libraryItem;

  const LibraryItemCard({super.key, required this.libraryItem});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    // print('libraryItem:  $libraryItem');
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        FocusScope.of(context).unfocus(); // Unfocus any input fields
        // ignore: avoid_print
        print('Card tap: ${libraryItem.title}');
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (ctx) => const Detail())
        );
      },
      child: Card(
        color: const Color(0x9907837F),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.white,
                    ),
                    onSelected: (value) {
                      FocusScope.of(context).unfocus();
                      if (value == 'edit') {
                        // ignore: avoid_print
                        print('Edit selected for ${libraryItem.title}');
                        // Navigate to edit page or show edit dialog
                      } else if (value == 'delete') {
                         // ignore: avoid_print
                         print('Delete selected for ${libraryItem.title}');
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Alert"),
                              content: const Text('Are you sure you want to delete this item?'),
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
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  )
                ],
              ),
              Row(
                children: [
                  Image.network(
                    'http://192.168.101.199:5173/server/src/uploads/${libraryItem.image}', // Replace with your image
                    width: 60,
                    height: 60,
                    // fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          libraryItem.title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Divider(),
                        // const SizedBox(height: 5),
                        Text(
                          libraryItem.description.length > 80
                              ? '${libraryItem.description.substring(0, 80)}...' // Limit to 100 characters
                              : libraryItem.description,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text('Present by: ${libraryItem.author}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
