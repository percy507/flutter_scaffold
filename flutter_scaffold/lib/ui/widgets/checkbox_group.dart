import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CheckBoxGroup extends StatefulWidget {
  CheckBoxGroup({
    this.value,
    this.onChange,
    this.options,
  });

  final List<String> value;
  final Function onChange;
  final List<String> options;

  @override
  CheckBoxGroupState createState() => CheckBoxGroupState();
}

class CheckBoxGroupState extends State<CheckBoxGroup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _value = widget.value ?? [];
    final options = widget.options;

    return Wrap(
      children: options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _value.contains(option),
              onChanged: (bool isChecked) {
                if (isChecked) {
                  _value.add(option);
                } else {
                  _value.remove(option);
                }

                widget.onChange([..._value]);
              },
            ),
            GestureDetector(
              child: Text(option.toString()),
              onTap: () {
                if (_value.contains(option)) {
                  _value.remove(option);
                } else {
                  _value.add(option);
                }

                widget.onChange([..._value]);
              },
            )
          ],
        );
      }).toList(),
    );
  }
}
