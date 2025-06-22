import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_wheel/generated/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF90A4AE),
        title: Text(AppLocalizations.of(context)!.settingsTitle, style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(AppLocalizations.of(context)!.theme),
            subtitle: const Text('Light / Dark'),
            onTap: () {
              // TODO: Implement theme switching
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(AppLocalizations.of(context)!.notifications),
            subtitle: const Text('Enable or disable reminders'),
            trailing:
                Switch(value: true, onChanged: (v) {}), // TODO: Bind to state
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: Text(AppLocalizations.of(context)!.cloudSync),
            subtitle: Text(AppLocalizations.of(context)!.backup),
            onTap: () async {
              // await CloudSyncService.backupData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Backup simulated (cloud sync coming soon)'),
                    backgroundColor: Color(0xFF90A4AE),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.about),
            subtitle: Text(
              AppLocalizations.of(context)?.appTitle ??
                  'Focus Wheel v1.0',
            ),
          ),
        ],
      ),
    );
  }
}
