import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/ui/styles/button.dart';
import 'package:myapp/services/service111.dart';

class Tab1Page extends StatefulWidget {
  @override
  Tab1PageState createState() => Tab1PageState();
}

class Tab1PageState extends State<Tab1Page> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _data = 'init data';
  String _imgUrl;

  Widget _myButton({
    @required String title,
    @required void Function() onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      child: ElevatedButton(
        child: Text(title),
        style: tabButtonStyle,
        onPressed: onPressed,
      ),
    );
  }

  void _showJokeDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        bool _dataLoading = false;
        String _joke;

        return StatefulBuilder(
          builder: (context, setState) {
            if (_joke == null && _dataLoading == false) {
              setState(() {
                _dataLoading = true;
              });

              Service111.getRandomJoke().then((dynamic value) {
                setState(() {
                  _dataLoading = false;
                  _joke = value['joke'] as String;
                });
              });
            }

            return SimpleDialog(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(Icons.face),
                    padding: EdgeInsets.only(right: 6),
                  ),
                  Text('随机笑话'),
                ],
              ),
              titlePadding: EdgeInsets.fromLTRB(12, 12, 12, 0),
              contentPadding: const EdgeInsets.all(12.0),
              children: [
                _dataLoading
                    ? Container(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Container(
                        constraints: BoxConstraints(
                          maxHeight: 200,
                        ),
                        child: SingleChildScrollView(
                          child: Text(_joke),
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _imgLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent progress,
  ) {
    final double value = progress?.expectedTotalBytes != null
        ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes
        : 0;
    return progress == null
        ? child
        : SizedBox(
            width: 100.0,
            height: 100.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 75,
                  height: 75,
                  child: CircularProgressIndicator(
                    semanticsValue: '0.5',
                    value: value,
                  ),
                ),
                Text('${(value * 100).toStringAsFixed(2)}%')
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tab1Page'),
      ),
      body: ListView(
        children: [
          _myButton(
            title: '改变数据',
            onPressed: () {
              setState(() {
                _data = 'data: ${Random().nextDouble()}';
              });
            },
          ),
          Center(
            child: Text(_data),
          ),
          Divider(),
          _myButton(
            title: '随机笑话',
            onPressed: _showJokeDialog,
          ),
          Divider(),
          _imgUrl == null
              ? _myButton(
                  title: '获取随机风景图',
                  onPressed: () {
                    _imgUrl = Service111.getBingRandomImageUrl();
                    setState(() {});
                  },
                )
              : Container(
                  margin: const EdgeInsets.all(40.0),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          _imgUrl,
                          loadingBuilder: _imgLoadingBuilder,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          _imgUrl =
                              '${Service111.getBingRandomImageUrl()}&rrr=${Random().nextDouble()}';
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
