import 'package:flutter/material.dart';
import '../widgets/agenda_timeline.dart';

class AgendaScreen extends StatelessWidget {
  void _exportAgenda(BuildContext context, String format) {
    // Implémentation fictive
    // TODO: remove or handle debug output instead of print ('Export Agenda as $format');
  }

  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EC1E4),
        title: Text('Agenda', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.white),
            tooltip: 'Export',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.picture_as_pdf, color: Color(0xFF6EC1E4)),
                        title: Text('Export as PDF'),
                        onTap: () {
                          Navigator.pop(context);
                          _exportAgenda(context, 'pdf');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.table_chart, color: Color(0xFF6EC1E4)),
                        title: Text('Export as CSV'),
                        onTap: () {
                          Navigator.pop(context);
                          _exportAgenda(context, 'csv');
                        },
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AgendaTimeline(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6EC1E4),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Container(),
          );
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
