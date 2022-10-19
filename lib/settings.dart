// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 中国网络业务提供商
enum ISP {
  /// 电信
  telecom,

  /// 联通
  unicom,

  /// 移动
  cmcc,
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  // https://flutter.cn/docs/cookbook/persistence/key-value
  late final SharedPreferences prefs;

  /// 认证主机
  String authHost = '10.31.0.10:801';
  final TextEditingController _authHostController = TextEditingController();

  /// 认证主机输入框
  TextFormField _authHostTextField() {
    return TextFormField(
      controller: _authHostController,
      decoration: const InputDecoration(
        labelText: '认证服务器',
        hintText: '[IP 地址 / 域名]:[端口号]',
      ),
      onChanged: (v) => setState(() => authHost = v),
    );
  }

  /// 学号
  String stuNum = '';
  final TextEditingController _stuNumController = TextEditingController();

  /// 学号输入框
  TextFormField _stuNumTextFormField() {
    return TextFormField(
      autofocus: true,
      controller: _stuNumController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: '学号'),
      onChanged: (v) => setState(() => stuNum = v),
    );
  }

  /// 网络业务提供商
  ISP isp = ISP.telecom;

  /// 网络业务提供商下拉按钮
  DropdownButton _ispDropdownButton() {
    return DropdownButton<ISP>(
      value: isp,
      items: const <DropdownMenuItem<ISP>>[
        DropdownMenuItem(value: ISP.telecom, child: Text('电信')),
        DropdownMenuItem(value: ISP.unicom, child: Text('联通')),
        DropdownMenuItem(value: ISP.cmcc, child: Text('移动')),
      ],
      onChanged: (v) => setState(() => isp = v ?? ISP.telecom),
    );
  }

  /// 密码
  String password = '';
  final TextEditingController _passwordController = TextEditingController();

  /// 密码输入框
  TextFormField _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(labelText: '密码'),
      onChanged: (v) => setState(() => password = v),
    );
  }

  /// 保存按钮
  Container _saveButton() {
    return Container(
      width: 800,
      padding: const EdgeInsets.only(top: 32),
      child: ElevatedButton(
        onPressed: () => _save(),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('保存', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Future<void> _save() async {
    prefs.setString('authHost', authHost);
    prefs.setString('stuNum', stuNum);
    prefs.setString('isp', isp.toString());
    prefs.setString('password', password);
    Navigator.pop(context);
  }

  Future<void> _initSettings() async {
    prefs = await SharedPreferences.getInstance();
    _authHostController.text = prefs.getString('authHost') ?? '10.31.0.10:801';
    _stuNumController.text = prefs.getString('stuNum') ?? '';
    switch (prefs.getString('isp')) {
      case 'ISP.unicom':
        setState(() => isp = ISP.unicom);
        break;
      case 'ISP.cmcc':
        setState(() => isp = ISP.cmcc);
        break;
      default:
        setState(() => isp = ISP.telecom);
    }
    _passwordController.text = password = prefs.getString('password') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _authHostTextField(),
              Row(
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Expanded(child: _stuNumTextFormField()),
                  const SizedBox(width: 8),
                  _ispDropdownButton(),
                ],
              ),
              _passwordFormField(),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
