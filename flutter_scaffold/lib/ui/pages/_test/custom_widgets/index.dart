import 'package:flutter/material.dart';

import 'package:myapp/ui/widgets/checkbox_group.dart';
import 'package:myapp/ui/widgets/progress_button.dart';
import 'package:myapp/ui/widgets/single_picker.dart';

class CustomWidgets extends StatefulWidget {
  @override
  CustomWidgetsState createState() => CustomWidgetsState();
}

class CustomWidgetsState extends State<CustomWidgets> {
  List<String> _checkboxGroupValue;
  dynamic _singlePickerValue;
  bool _progressButtonLoading = false;

  Widget _buildListItem(BuildContext context, Map item) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            child: Text(
              item['title'] as String,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'value:  ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(text: item['value'] as String),
                ],
              ),
            ),
          ),
          item['widget'] as Widget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _list = [
      {
        'title': 'checkbox_group',
        'value': _checkboxGroupValue.toString(),
        'widget': CheckBoxGroup(
          value: _checkboxGroupValue,
          options: const [
            'Python',
            'Ruby',
            'PHP',
            'JavaScript',
            'Dart',
            'Lua',
            'SQL',
            'C#',
            'Go',
          ],
          onChange: (List<String> value) {
            setState(() {
              _checkboxGroupValue = value;
            });
          },
        ),
      },
      {
        'title': 'single_picker',
        'value': _singlePickerValue.toString(),
        'widget': SinglePicker(
          value: _singlePickerValue,
          placeholder: '请选择身高',
          onChange: (dynamic value) {
            setState(() {
              _singlePickerValue = value;
            });
          },
          items: List<double>.generate(60, (i) => i + 140.0),
        ),
      },
      {
        'title': 'progress_button',
        'value': _progressButtonLoading.toString(),
        'widget': ProgressButton(
          loading: _progressButtonLoading,
          title: '提交',
          onPressed: () {
            setState(() {
              _progressButtonLoading = true;
            });

            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                _progressButtonLoading = false;
              });
            });
          },
        ),
      },
    ];

    final List<Widget> listViewChildren = _list
        .map(
          (item) => _buildListItem(
            context,
            item,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义控件'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          color: Colors.black38,
          context: context,
          tiles: listViewChildren,
        ).toList(),
      ),
    );
  }
}
