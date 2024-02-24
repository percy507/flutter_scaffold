import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class AgreementPage extends StatelessWidget {
  AgreementPage({
    @required this.title,
    @required this.agreementPath,
  });

  final String title;
  final String agreementPath;

  Future<dynamic> _loadFile() async {
    return await rootBundle.loadString(agreementPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<dynamic>(
          future: _loadFile(),
          builder: (
            BuildContext context,
            AsyncSnapshot<dynamic> snapshot,
          ) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('加载中...');
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Html(
                    data: snapshot.data as String,
                    onLinkTap: (url) {
                      // open url in a webview
                    },
                    onImageTap: (src) {
                      // Display the image in large form.
                    },
                    style: {
                      'h3': Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                      'div': Style(
                        color: Colors.black87,
                      ),
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
