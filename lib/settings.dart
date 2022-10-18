import 'package:flutter/material.dart';

/// 网络业务提供商
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
  /// 认证主机
  String authHost = '10.31.0.10:801';

  /// 学号
  String studentNumber = '';

  /// 网络业务提供商
  ISP isp = ISP.telecom;

  /// 密码
  String userPassword = '';

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
              TextFormField(
                initialValue: authHost,
                decoration: const InputDecoration(
                  labelText: '认证服务器',
                  hintText: '[IP 地址 / 域名]:[端口号]',
                ),
              ),
              Row(
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '学号'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<ISP>(
                    value: isp,
                    items: const <DropdownMenuItem<ISP>>[
                      DropdownMenuItem(value: ISP.telecom, child: Text('电信')),
                      DropdownMenuItem(value: ISP.unicom, child: Text('联通')),
                      DropdownMenuItem(value: ISP.cmcc, child: Text('移动')),
                    ],
                    onChanged: (value) => setState(() => isp = value ?? ISP.cmcc),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码',
                ),
              ),
              Container(
                width: 800,
                padding: const EdgeInsets.only(top: 32),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('保存', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
