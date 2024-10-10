import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myproject/screens/detail.dart';
import 'package:http/http.dart' as http;
import 'package:myproject/screens/editPresentation.dart';

class LibraryItem {
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
  final String userName;

  LibraryItem({
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
    required this.userName,
  });
}

class LibraryItemCard extends StatefulWidget {
  final VoidCallback onChange;
  final LibraryItem libraryItem;
  const LibraryItemCard(
      {super.key, required this.libraryItem, required this.onChange});

  @override
  State<LibraryItemCard> createState() => _LibraryItemCardState();
}

class _LibraryItemCardState extends State<LibraryItemCard> {
  String userId = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      userId = localStorage.getItem('userId') ?? "";
      userRole = localStorage.getItem('userRole') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Unfocus any input fields
        var libId = (widget.libraryItem.libId).toString();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => Detail(
                      libraryId: libId,
                    )));
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
                  (userRole.isNotEmpty ||
                          userId == widget.libraryItem.createdBy)
                      ? PopupMenuButton<String>(
                          icon: const Icon(Icons.more_horiz_rounded,
                              color: Colors.white),
                          onSelected: (value) {
                            FocusScope.of(context).unfocus();
                            if (value == 'edit') {
                              var libId = (widget.libraryItem.libId).toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPresentation(
                                          libraryId: libId,
                                          onEdit: () {
                                            widget.onChange();
                                            Navigator.pop(context);
                                          })));
                              // Navigate to edit page or show edit dialog
                            } else if (value == 'delete') {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text("Alert"),
                                  content: const Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // Handle delete action
                                        FocusScope.of(context).unfocus();
                                        final url = Uri.parse(
                                            'http://192.168.101.199:3001/delete/library/${widget.libraryItem.libId}');
                                        await http.delete(url);
                                        widget.onChange();
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
                      : const SizedBox(
                          height: 50,
                        ),
                ],
              ),
              Row(
                children: [
                  Image.network(
                    'http://192.168.101.199:5173/server/src/uploads/${widget.libraryItem.image}', // Replace with your image
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.libraryItem.libName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Divider(),
                        Text(
                          widget.libraryItem.description.length > 90
                              ? '${widget.libraryItem.description.substring(0, 90)}...' // Limit to 100 characters
                              : widget.libraryItem.description,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text('Present by: ${widget.libraryItem.userName}',
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
