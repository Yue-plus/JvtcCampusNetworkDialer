import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Settings> {
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
                initialValue: '10.31.0.10:801',
                decoration: const InputDecoration(
                  labelText: '认证服务器',
                  hintText: '[IP 地址 / 域名]:[端口号]',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '学号'),
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  labelText: '密码',
                ),
              ),
              Container(
                width: 800,
                padding: const EdgeInsets.only(top: 32),
                child: ElevatedButton(
                  onPressed: () {},
                  // style: const ButtonStyle(padding: EdgeInsets.all(8)),
                  child: const Text('保存', style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
