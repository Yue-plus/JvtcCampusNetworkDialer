import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

import 'settings.dart';
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

  /// 今日星期、断网时段
  late String todayInfo;

  /// 网络状态
  String _netInfo = '未连接到校园网';

  Row _buttonGroup() {
    return Row(
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
          // onPressed: () => setState(() => _isLinked = !_isLinked),
          onPressed: _linkStart,
        ),
      ],
    );
  }

  Future<void> _linkStart() async {
    setState(() {
      _isLinked = false;
      _netInfo = '正在连接……';
    });

    var prefs = await SharedPreferences.getInstance();
    var authHost = prefs.getString('authHost') ?? '10.31.0.10:801';
    var stuNum = prefs.getString('stuNum') ?? '';
    var password = prefs.getString('password') ?? '';

    String isp;
    switch (prefs.getString('isp')) {
      case 'ISP.unicom':
        isp = 'unicom';
        break;
      case 'ISP.cmcc':
        isp = 'cmcc';
        break;
      default:
        isp = 'telecom';
    }

    try {
      var response = await get(Uri.parse(
              'http://$authHost/eportal/portal/login?user_account=$stuNum%40$isp&user_password=$password'))
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        setState(() => _isLinked = true);
      }
      setState(() => _netInfo = response.body);
    } on TimeoutException {
      setState(() => _netInfo = '认证服务器超时未响应！');
    } catch (e) {
      setState(() => _netInfo = e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _linkStart();

    // 显示今日星期、断网时段
    switch (DateTime.now().weekday) {
      case 1:
        todayInfo = '今天是星期一  23:50 需重新登入';
        break;
      case 2:
        todayInfo = '今天是星期二  23:50 需重新登入';
        break;
      case 3:
        todayInfo = '今天是星期三  23:50 到次日 7 点断网';
        break;
      case 4:
        todayInfo = '今天是星期四  23:50~24:00 点断网';
        break;
      case 5:
        todayInfo = '今天是星期五  23:50 需重新登入';
        break;
      case 6:
        todayInfo = '今天是星期六  23:50 到次日 7 点断网';
        break;
      case 7:
        todayInfo = '今天是星期日  22:50~24:00 断网';
        break;
      default:
        todayInfo = '(っ °Д °;)っ';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: () => launchUrl(Uri.parse(
                'https://github.com/Yue-plus/JvtcCampusNetworkDialer')),
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isLinked ? Icons.link : Icons.link_off,
              size: 256,
              color: _isLinked ? Colors.green : Colors.yellow,
            ),
            Text(todayInfo, style: const TextStyle(color: Colors.grey)),
            Text(_netInfo, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buttonGroup(),
          ],
        ),
      ),
    );
  }
}
