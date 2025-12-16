import 'package:flutter/material.dart';

class PrefsViewPage extends StatefulWidget {
  static String name = '/prefs-view';

  final int id;

  const PrefsViewPage({super.key, required this.id});

  @override
  State createState() => _PrefsViewPageState();
}

class _PrefsViewPageState extends State<PrefsViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences View Page')),
      body: const Center(child: Text('Preferences View Content')),
    );
  }
}
