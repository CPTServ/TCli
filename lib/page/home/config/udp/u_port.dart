import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_client/main.dart';
import 'package:transfer_client/page/home/config/page.dart';

class UPort extends StatelessWidget implements ConfigWiget{
  UPort({super.key}) {
    textEditingController = TextEditingController();
    textEditingController.text = GlobalConfig.u_port.toString();
    fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
  }
  Config global = GlobalConfig;
  static final String PrefKey = "config.u_port";
  late FToast fToast;

  static void setConfig(Config global, int val) {
    global.u_port = val;
  }

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(0.0),
      color: Colors.greenAccent,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Port saved"),
      ],
    ),
  );

  late TextEditingController textEditingController;
  Timer timer = Timer(const Duration(microseconds: 0), () {});
  void onHostCommit(String p) async {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 1), () async {
      int port = int.parse(p);
      setConfig(global, port);
      (await SharedPreferences.getInstance()).setInt(PrefKey, port);
      fToast.showToast(child: toast, gravity: ToastGravity.TOP_RIGHT);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.white,
      leading: const Icon(
        Icons.lens_blur,
        size: 40,
        color: Colors.white,
      ),
      title: const Text("Port"),
      subtitle: TextField(
        keyboardType: TextInputType.number,
        controller: textEditingController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onSubmitted: onHostCommit,
        onChanged: onHostCommit,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white))),
      ),
    );
  }

  @override
  static Future<void> initConfig(Config global, SharedPreferences prefs) async {
    int a;
    try {
      a = prefs.getInt(PrefKey)!;
    } catch (err) {
      a = 15002;
    }
    setConfig(global, a);
  }
}
