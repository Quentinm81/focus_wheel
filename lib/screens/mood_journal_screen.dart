import 'package:flutter/material.dart';
import '../widgets/mood_journal.dart';

class MoodJournalScreen extends StatelessWidget {
  const MoodJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF64B5F6),
        title: const Text('Mood Journal', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const MoodJournal(),
    );
  }
}
