import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_client/api/fetch.dart';
import 'package:transfer_client/page/home/main/ftoast.dart';
import 'package:transfer_client/page/home/main/message_item.dart';

import '../../../main.dart';

class RawMessage {
  RawMessage(Map<String, dynamic> raw) {
    this.type = raw["type"];
    this.id = raw["id"];
    this.time = raw["time"];
    switch (this.type) {
      case TYPE_TEXT:
        this.data_file = null;
        this.data_text = raw["data"];
        break;
      case TYPE_BYTE:
        this.data_text = null;
        this.data_file = RawMessageFile(
            filename: raw["data"]["filename"], size: raw["data"]["size"]);
    }
  }

  late final int type;
  late final String id;
  late final int time;
  late final String? data_text;
  late final RawMessageFile? data_file;
}

class RawMessageFile {
  RawMessageFile({required this.filename, required this.size});

  final String filename;
  final int size;
}

class Message {
  Message(
      {required this.type,
      required this.title,
      required this.content,
      required this.id,
      required Map<String, dynamic> raw_map,
      this.error = false,
      this.icon = Icons.abc}) {
    if (this.error) return;
    this.raw = RawMessage(raw_map);
  }

  final String title;
  final String content;
  final IconData icon;
  final bool error;
  final String id;
  final int type;
  late final RawMessage raw;
}

class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageList();
}

class _MessageList extends State<MessageList> {
  _MessageList() {
    fToast = FToast();
    fToast.init(navigatorKey.currentContext!);
  }

// class MessageList extends StatelessWidget {
  List<Message> messages = [];
  Object? error;
  late FToast fToast;

  Widget newToast(String content, BuildContext context) {
    double? width;
    try {
      width = MediaQuery.of(context).size.width;
    } catch (err) {
      log("New Toast ERROR: $err");
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: Colors.redAccent,
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 12.0,
          ),
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void refresh(List<Message> messages, Object? error) async {
    log("refreshing");
    if (mounted) {
      setState(() {
        log("setting state");
        this.messages = messages;
        this.error = error;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (error != null) {
        GlobalFtoast.error(error.toString(), context, immediate: true);
      }
    });
  }

  @override
  void dispose() {
    log("dispose msg list");
    GlobalFetcher.clearCallback();
    GlobalFetcher.stopSync();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    GlobalFetcher.startSync();
    GlobalFetcher.registerCallback(refresh);
    log("init state msg list");
  }

  Widget _getComponent() {
    if (this.error != null) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Text(
          'Error: ${this.error}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ));
    } else {
      return ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          Message m = messages[index];
          return MessageItem(message: m);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: UniqueKey(), child: this._getComponent());
    // this._getComponent(),
    return Column(
      key: UniqueKey(),
      children: [
        Expanded(child: this._getComponent()),
        // this._getComponent(),
      ],
    );
  }
}
