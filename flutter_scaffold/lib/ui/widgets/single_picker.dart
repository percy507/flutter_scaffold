import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SinglePicker extends StatefulWidget {
  SinglePicker({
    this.value,
    this.placeholder,
    this.onChange,
    this.items,
  });

  final dynamic value;
  final String placeholder;
  final Function onChange;
  final List<dynamic> items;

  @override
  SinglePickerState createState() => SinglePickerState();
}

class SinglePickerState extends State<SinglePicker> {
  final _headerButtonTextStyle = TextStyle(
    color: Colors.blue,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        widget.value == null ? widget.placeholder : widget.value.toString(),
      ),
      onPressed: () {
        showModalBottomSheet<dynamic>(
          context: context,
          builder: (BuildContext builder) {
            final _scrollController = FixedExtentScrollController(
              initialItem: widget.value != null ? widget.items.indexOf(widget.value) : 0, // 初始化值
            );

            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: Column(
                children: [
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      // 底部 border
                      border: Border(
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '取消',
                            style: _headerButtonTextStyle,
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            final int position = _scrollController.selectedItem;

                            widget.onChange(widget.items[position]);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '确认',
                            style: _headerButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _scrollController,
                      useMagnifier: true,
                      magnification: 1.1,
                      itemExtent: 40,
                      onSelectedItemChanged: (int position) {
                        print(position);
                      },
                      children: widget.items.map((dynamic item) {
                        return Center(
                          child: Text(item.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
