import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jvtc_campus_network_dialer/settings.dart';

import 'button.dart';

const String title = '九职校园网拨号器';

void main() => runApp(MaterialApp(
      title: title,
      color: const Color(0xFF22BBFF),
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => _Home(),
        '/settings': (BuildContext context) => const Settings(),
      },
      supportedLocales: const [
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hans',
          countryCode: 'CN',
        ),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    ));

class _Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  bool _isLinked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isLinked ? Icons.link : Icons.link_off,
              size: 256,
              color: _isLinked ? Colors.green : Colors.yellow,
            ),
            const Text('log...'),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Button(
                  icon: Icons.settings,
                  text: '设置',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
                const SizedBox(width: 12),
                Button(
                  icon: Icons.refresh,
                  text: '重连',
                  onPressed: () => setState(() => _isLinked = !_isLinked),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
