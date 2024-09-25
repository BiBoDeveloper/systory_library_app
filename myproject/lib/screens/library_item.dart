import 'package:flutter/material.dart';
import 'package:myproject/screens/detail.dart';


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
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        FocusScope.of(context).unfocus(); // Unfocus any input fields
        // ignore: avoid_print
        print('Card tap: ${libraryItem.title}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const Detail()));
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
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
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