import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  ProgressButton({
    @required this.loading,
    @required this.title,
    @required this.onPressed,
  });

  final bool loading;
  final String title;
  final void Function() onPressed;

  @override
  ProgressButtonState createState() => ProgressButtonState();
}

class ProgressButtonState extends State<ProgressButton> {
  @override
  Widget build(BuildContext context) {
    final Widget child = widget.loading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.black26),
                  ),
                ),
              ),
              Text(widget.title),
            ],
          )
        : Text(widget.title);

    return ElevatedButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
      onPressed: widget.loading ? null : widget.onPressed,
    );
  }
}
