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
  final _formKey = GlobalKey<FormState>();

  // https://flutter.cn/docs/cookbook/persistence/key-value
  late final SharedPreferences prefs;

  /// 认证主机
  late String authHost;
  final TextEditingController _authHostController = TextEditingController();

  /// 认证主机输入框
  TextFormField _authHostTextField() {
    return TextFormField(
      controller: _authHostController,
      validator: (v) => v!.trim().isNotEmpty ? null : "认证主机不能为空！",
      decoration: const InputDecoration(
        labelText: '认证服务器',
        hintText: '[IP 地址 / 域名]:[端口号]',
      ),
      onChanged: (v) => setState(() => authHost = v),
    );
  }

  /// 学号
  late String stuNum;
  final TextEditingController _stuNumController = TextEditingController();

  /// 学号正则验证；学号应该为 9 位数字
  final RegExp stuNumRegExp = RegExp(r'\d{8}[0-9]');

  /// 学号输入框
  TextFormField _stuNumTextFormField() {
    return TextFormField(
      autofocus: true,
      controller: _stuNumController,
      validator: (v) => stuNumRegExp.hasMatch(v!.trim()) ? null : '学号应为 9 位数字！',
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
  late String password;
  final TextEditingController _passwordController = TextEditingController();

  /// 密码输入框
  TextFormField _passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      validator: (v) => v!.trim().isNotEmpty ? null : "密码不能为空！",
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
        onPressed: () => _formKey.currentState!.validate() ? _save() : null,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('保存', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Future<void> _save() async {
    prefs.setString('authHost', authHost.trim());
    prefs.setString('stuNum', stuNum.trim());
    prefs.setString('isp', isp.toString());
    prefs.setString('password', password.trim());
    Navigator.pop(context);
  }

  Future<void> _initSettings() async {
    prefs = await SharedPreferences.getInstance();

    // 初始化本类成员变量
    authHost = prefs.getString('authHost') ?? '10.31.0.10:801';
    stuNum = prefs.getString('stuNum') ?? '';
    password = password = prefs.getString('password') ?? '';

    // 初始化界面
    _authHostController.text = authHost;
    _stuNumController.text = stuNum;
    _passwordController.text = password;
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
      ),
    );
  }
}
