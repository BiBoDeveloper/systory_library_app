import 'package:flutter/material.dart';

class InstallationTable extends StatelessWidget {
  final List<Map<String, String>> installationDes;
  final Function(String, int) onRemoveRow;
  final String type;

  InstallationTable({required this.installationDes, required this.onRemoveRow, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Table(
        defaultColumnWidth: const FixedColumnWidth(90.0),
        columnWidths: const {
          0: FixedColumnWidth(90.0),
          1: FixedColumnWidth(130.0),
          2: FixedColumnWidth(100.0),
          3: FixedColumnWidth(30.0),
        },
        children: [
          TableRow(
            children: [
              _buildHeaderCell('Title'),
              _buildHeaderCell('Description'),
              _buildHeaderCell('Example (Code)'),
              const SizedBox.shrink(),
            ],
          ),
          for (int i = 0; i < installationDes.length; i++)
            TableRow(
              children: [
                _buildDataCell(installationDes[i]['title'] ?? ''),
                _buildDataCell(installationDes[i]['description'] ?? ''),
                _buildDataCell(installationDes[i]['example'] ?? ''),
                SizedBox(
                  height: 30.0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 12.0,
                      onPressed: () {
                        onRemoveRow(type,i);
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      color: Colors.cyan,
      child: SizedBox(
        height: 30.0,
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 12.0, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.1),
      ),
      child: SizedBox(
        height: 30.0,
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 12.0)),
        ),
      ),
    );
  }
}
