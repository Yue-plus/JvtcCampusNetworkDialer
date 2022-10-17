import 'package:flutter/material.dart';

import 'button.dart';

void main() => runApp(const DialerApp());

class DialerApp extends StatefulWidget {
  const DialerApp({super.key});

  static const String title = '九职校园网';

  @override
  State<StatefulWidget> createState() => _DialerAppState();
}

class _DialerAppState extends State<DialerApp> {
  final IconData _linkState = Icons.link_off;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: DialerApp.title,
      color: const Color(0xFF22BBFF),
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text(DialerApp.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_linkState, size: 256, color: Colors.grey),
              const Text('log...'),
              const SizedBox(height: 32),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(icon: Icons.settings, text: '设置', onPressed: () {}),
                  const SizedBox(width: 12),
                  Button(icon: Icons.refresh, text: '重连', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
