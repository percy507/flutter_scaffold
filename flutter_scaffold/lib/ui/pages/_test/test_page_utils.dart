import 'package:flutter/material.dart';
import 'package:myapp/utils/navigator_utils.dart';

class TestPageUtils {
  static Widget myButton({String title, void Function() onPressed}) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Center(
        child: SizedBox(
          width: 300,
          child: ElevatedButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  static void myDialog({
    String title,
    String content,
  }) {
    showDialog<dynamic>(
      context: NavigatorUtils.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
