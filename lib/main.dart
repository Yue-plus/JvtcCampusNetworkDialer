import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

import 'settings.dart';

const String title = '九职校园网拨号器';

void main() => runApp(MaterialApp(
      title: title,
      color: const Color(0xFF22BBFF),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
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

  /// 今日星期、断网时段等……
  late String todayInfo;

  /// 网络状态
  String _netInfo = '未连接到校园网';

  /// 自动重播计数
  int _reconnectCount = 0;

  /// 断线计数
  int _disconnection = 0;

  Future<void> _linkStart() async {
    setState(() {
      _isLinked = false;
      _netInfo = '正在连接……';
    });

    var prefs = await SharedPreferences.getInstance();
    var authHost = prefs.getString('authHost') ?? '10.31.0.10:801';
    var stuNum = prefs.getString('stuNum') ?? '';
    var password = prefs.getString('password') ?? '';
    var reconnectInterval = prefs.getDouble('reconnectInterval') ?? 8.0;

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

    void link() async {
      try {
        var response = await get(Uri.parse(
                'http://$authHost/eportal/portal/login?user_account=$stuNum%40$isp&user_password=$password'))
            .timeout(const Duration(seconds: 2));
        if (response.body.indexOf("已经在线") > 0 ||
            response.body.indexOf("认证成功") > 0) {
          setState(() => {_isLinked = true, _reconnectCount++});
        }
        setState(() => _netInfo = response.body);
      } on TimeoutException {
        setState(() => _netInfo = '认证服务器超时未响应！');
        _isLinked = false;
        _reconnectCount++;
        _disconnection++;
      } catch (e) {
        setState(() {
          _isLinked = false;
          _netInfo = e.toString();
          _reconnectCount++;
          _disconnection++;
        });
      }
    }

    link();
    Timer.periodic(
      Duration(milliseconds: (1000 * reconnectInterval).toInt()),
      (timer) => link(),
    );
  }

  @override
  void initState() {
    super.initState();
    _linkStart();

    // 显示今日星期、断网时段
    switch (DateTime.now().weekday) {
      case 1:
        todayInfo = '今天是星期一  不断网';
        break;
      case 2:
        todayInfo = '今天是星期二  不断网';
        break;
      case 3:
        todayInfo = '今天是星期三  23:50 到次日 7 点断网';
        break;
      case 4:
        todayInfo = '今天是星期四  22:50~24:00 点断网';
        break;
      case 5:
        todayInfo = '今天是星期五  不断网';
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
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings),
          ),
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
            Text(todayInfo),
            const SizedBox(height: 12),
            Text(_netInfo, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text('本次运行已自动重拨 $_reconnectCount 次，其中失败 $_disconnection 次'),
          ],
        ),
      ),
    );
  }
}
