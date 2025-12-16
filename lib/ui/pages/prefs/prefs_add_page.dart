import 'package:flutter/material.dart';

class PrefsAddPage extends StatefulWidget {
  static String name = '/prefs-add';

  const PrefsAddPage({super.key});

  @override
  State createState() => _PrefsAddPageState();
}

class _PrefsAddPageState extends State<PrefsAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences Add Page')),
      body: const Center(child: Text('Preferences Add Content')),
    );
  }
}
