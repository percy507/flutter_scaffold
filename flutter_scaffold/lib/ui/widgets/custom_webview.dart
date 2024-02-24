import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  CustomWebView({
    @required this.initialUrl,
  });

  final String initialUrl;

  @override
  CustomWebViewState createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  WebViewController _webViewController;
  final Completer<bool> _finishedCompleter = Completer();

  ValueNotifier<bool> canGoBack = ValueNotifier(false);
  ValueNotifier<bool> canGoForward = ValueNotifier(false);

  String _pageTitle = 'Loading';

  /// 刷新导航按钮
  ///
  /// 目前主要用来控制 '前进','后退'按钮是否可以点击
  /// 但是目前该方法没有合适的调用时机.
  /// 在[onPageFinished]中,会遗漏正在加载中的状态
  /// 在[navigationDelegate]中,会存在页面还没有加载就已经判断过了.
  void refreshNavigator() {
    /// 是否可以后退
    _webViewController.canGoBack().then((value) {
      return canGoBack.value = value;
    });

    /// 是否可以前进
    _webViewController.canGoForward().then((value) {
      return canGoForward.value = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_webViewController != null && await _webViewController.canGoBack()) {
          _webViewController.goBack();
          return false;
        }

        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: WebViewTitle(
            title: _pageTitle,
            future: _finishedCompleter.future,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // appbar 的返回按钮，直接关闭webview页面
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(
              tooltip: '浏览器打开',
              icon: Icon(Icons.language),
              onPressed: () async {
                final String currentUrl = await _webViewController.currentUrl();

                if (await canLaunch(currentUrl)) {
                  launch(
                    currentUrl,
                    forceSafariVC: false,
                  );
                }
              },
            ),
            WebViewPopupMenu(
              _webViewController,
            )
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted, // 允许执行JavaScript
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.startsWith('http')) {
                return NavigationDecision.navigate;
              } else {
                if (await canLaunch(request.url)) {
                  launch(request.url);
                }
                return NavigationDecision.prevent;
              }
            },
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
            },
            onPageFinished: (String value) async {
              if (!_finishedCompleter.isCompleted) {
                _finishedCompleter.complete(true);
              }

              _webViewController.getTitle().then((String title) {
                setState(() {
                  _pageTitle = title;
                });
              });

              refreshNavigator();
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: IconTheme(
            data: Theme.of(context).iconTheme.copyWith(opacity: 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ValueListenableBuilder(
                  valueListenable: canGoBack,
                  builder: (BuildContext context, bool value, Widget child) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: value
                          ? () {
                              _webViewController.goBack();
                              refreshNavigator();
                            }
                          : null,
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: canGoForward,
                  builder: (BuildContext context, bool value, Widget child) {
                    return IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: value
                          ? () {
                              _webViewController.goForward();
                              refreshNavigator();
                            }
                          : null,
                    );
                  },
                ),
                IconButton(
                  tooltip: '刷新',
                  icon: const Icon(Icons.autorenew),
                  onPressed: () {
                    _webViewController.reload();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebViewTitle extends StatelessWidget {
  WebViewTitle({this.title, this.future});

  final String title;
  final Future<bool> future;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FutureBuilder<bool>(
          future: future,
          initialData: false,
          builder: (context, snapshot) {
            return snapshot.data
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Theme(
                      data: ThemeData(
                        cupertinoOverrideTheme: CupertinoThemeData(
                          brightness: Brightness.dark,
                        ),
                      ),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  );
          },
        ),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }
}

class WebViewPopupMenu extends StatelessWidget {
  WebViewPopupMenu(
    this.controller,
  );

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(0, kToolbarHeight),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem(
            height: 28,
            child: WebViewPopupMenuItem<dynamic>(Icons.share, '分享'),
            value: 2,
          ),
          // PopupMenuDivider(),
        ];
      },
      onSelected: (int value) async {
        switch (value) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            Share.share('这里是\n分享的文本。。。。。');
            break;
        }
      },
    );
  }
}

class WebViewPopupMenuItem<T> extends StatelessWidget {
  WebViewPopupMenuItem(this.iconData, this.text, {this.color});

  final IconData iconData;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          size: 20,
          color: color ?? Theme.of(context).textTheme.bodyText1.color,
        ),
        SizedBox(
          width: 20,
        ),
        Text(text)
      ],
    );
  }
}
