import 'package:flutter/material.dart';

import 'loading/loading_layout.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [widget.child, const LoadingLayout()]);
  }
}
