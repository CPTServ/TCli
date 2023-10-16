import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transfer_client/api/utserv.dart';

// class MessageTextarea extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MessageTextarea();
// }
//
// class _MessageTextarea extends State<MessageTextarea> {
class MessageTextarea extends StatelessWidget {
  MessageTextarea({required this.textEditingController, super.key});
  final TextEditingController textEditingController;

  void _tservWrapper(Function function) async {
    String msg = "";
    try {
      msg = await function();
    } catch (err) {
      Fluttertoast.showToast(msg: "TServ Error: $err");
    }
    Fluttertoast.showToast(msg: msg);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableScrollableSheet(
        initialChildSize: 0.4, // 初始抽屉高度占整个屏幕高度的比例
        minChildSize: 0.1, // 抽屉最小高度占整个屏幕高度的比例
        maxChildSize: 1.0, // 抽屉最大高度占整个屏幕高度的比例
        builder: (context, controller) {
          return Container(
            color: Colors.grey[200],
            child: SingleChildScrollView(
              controller: controller,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: textEditingController,
                        minLines: 10,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Enter your text',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                            },
                            child: Text('Upload file'),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              _tservWrapper(() {
                                return UTServ.uploadText(textEditingController.value.text);
                              });
                            },
                            child: Text('Upload text'),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
    );
  }
}
