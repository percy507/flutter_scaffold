import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';

class FlutterHtmlTest extends StatefulWidget {
  @override
  FlutterHtmlTestState createState() => FlutterHtmlTestState();
}

class FlutterHtmlTestState extends State<FlutterHtmlTest> {
  final String str = '''
    <div>
      <h1>Demo Page</h1>
      <p>This is a <a href="https://github.com">fantastic product</a> that you should buy!</p>
      
      <div>
        <h3>gif图片</h3>
        <img style="-webkit-user-select: none;margin: auto;" src="https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201508%2F02%2F20150802175032_h3Wyt.gif&amp;refer=http%3A%2F%2Fc-ssl.duitang.com&amp;app=2002&amp;size=f9999,10000&amp;q=a80&amp;n=0&amp;g=0n&amp;fmt=jpeg?sec=1611902438&amp;t=432a1c8675deaae25b9758ccdc7c8d2b" alt="xxx.gif" />
      </div>

      <div>
        <h3>jpg图片</h3>
        <img style="-webkit-user-select: none;margin: auto;" src="https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3539382316,2908016499&amp;fm=26&amp;gp=0.jpg" />
      </div>

      <h3 style="color:red;">Features</h3>
      <ul>
        <li>It actually works</li>
        <li>It exists, <a href="https://baidu.com">click link</a></li>
        <li>It doesn't cost much!</li>
      </ul>
      <!--You can pretty much put any html in here!-->

      <div>
        <h3>custom element</h3>
        <flutter></flutter> <!-- custom element -->
        <br />
        <flutter horizontal></flutter>
      </div>
    </div>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_html'),
      ),
      body: ListView(
        children: [
          Html(
            data: str,
            onLinkTap: (url) {
              TestPageUtils.myDialog(
                title: 'onLinkTap',
                content: 'url: $url',
              );
            },
            onImageTap: (src) {
              TestPageUtils.myDialog(
                title: 'onImageTap',
                content: 'src: $src',
              );
            },
            style: {
              'div': Style(
                fontSize: const FontSize(16),
              ),
              'li': Style(
                fontWeight: FontWeight.w600,
              ),
            },
            customRender: {
              'flutter': (
                RenderContext context,
                Widget child,
                Map<String, String> attributes,
                dom.Element el,
              ) {
                return FlutterLogo(
                  style: (attributes['horizontal'] != null)
                      ? FlutterLogoStyle.horizontal
                      : FlutterLogoStyle.markOnly,
                  textColor: context.style.color,
                  size: context.style.fontSize.size * 5,
                );
              },
            },
          ),
        ],
      ),
    );
  }
}
