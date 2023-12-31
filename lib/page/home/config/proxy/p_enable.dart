import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_client/api/proxy.dart';
import 'package:transfer_client/page/home/config/page.dart';
import 'package:transfer_client/page/home/main/ftoast.dart';

class PEnable extends StatefulWidget implements ConfigWiget {
  PEnable({super.key});

  @override
  State<StatefulWidget> createState() => _PEnable();

  Config global = GlobalConfig;
  static final String PrefKey = "config.p_enable";

  static void setConfig(Config global, bool val) {
    global.p_enable = val;
  }

  @override
  static Future<void> initConfig(Config global, SharedPreferences prefs) async {
    bool a;
    try {
      a = prefs.getBool(PrefKey)!;
    } catch (err) {
      a = false;
    }
    setConfig(global, a);
  }
}

class _PEnable extends State<PEnable> {
  _PEnable() {
    textEditingController.text = GlobalConfig.p_enable.toString();
  }

  TextEditingController textEditingController = TextEditingController();
  Timer timer = Timer(const Duration(microseconds: 0), () {});

  void onCommit(bool p) async {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 1), () async {
      (await SharedPreferences.getInstance())
          .setBool(PEnable.PrefKey, GlobalConfig.p_enable);
      GlobalFtoast.success("State Saved", null, immediate: true);
    });
    if (p) {
      GlobalProxy.startProxy();
    } else {
      GlobalProxy.stopProxy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
          height: 80,
        ),
        const Icon(
          Icons.network_ping,
          size: 40,
          color: Colors.white,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            "Proxy enable",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Switch(
          value: GlobalConfig.p_enable,
          onChanged: (val) {
            onCommit(val);
            setState(() {
              GlobalConfig.p_enable = val;
            });
          },
        ),
        const SizedBox(
          width: 20,
          height: 80,
        ),
      ],
    );
  }
}
