import 'package:flutter/material.dart';
import 'package:myproject/screens/editExample.dart';

class InstallationTable extends StatelessWidget {
  final List<Map<String, String>> installationDes;
  final Function(String, int) onRemoveRow;
  final Function(String, String, String, String, int) onEditRow;
  final String type;

  const InstallationTable(
      {super.key,
      required this.installationDes,
      required this.onRemoveRow,
      required this.onEditRow,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: ListView.builder(
        shrinkWrap:
            true, // Ensures that the inner ListView takes only as much space as needed
        physics:
            const NeverScrollableScrollPhysics(), // Prevents inner ListView from scrolling independently
        itemCount: installationDes.length,
        itemBuilder: (context, index) {
          var items = installationDes[index];
          return Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(width: 10,),
                    Text(
                      '${items['title']}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => EditExample(
                                      onEditInstallation: (value) {
                                        onEditRow(
                                            type,
                                            value['title'],
                                            value['description'],
                                            value['example'],
                                            index);
                                      },
                                      oldData: items,
                                    )));
                      },
                      child: const Icon(Icons.edit),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        onRemoveRow(type, index);
                      },
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
