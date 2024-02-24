import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:myapp/ui/widgets/progress_button.dart';
import 'package:myapp/utils/dio/http.dart';
import 'package:myapp/utils/path_utils.dart';

class DioTest extends StatefulWidget {
  @override
  DioTestState createState() => DioTestState();
}

class DioTestState extends State<DioTest> {
  bool _loadingGet = false;
  final bool _loadingPostJson = false;
  final bool _loadingPostFormData = false;
  final bool _loadingPostFormUrlEncoded = false;
  final bool _loadingPut = false;
  final bool _loadingDelete = false;

  bool _loadingDownload = false;
  String _downloadProgress;
  CancelToken _cancelDownloadToken;

  bool _loadingException = false;

  Widget columnItem({Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SizedBox(
          width: 250,
          child: child,
        ),
      ),
    );
  }

  void _requestGet() {
    const String url = 'https://api.vvhan.com/api/xh?type=json';

    setState(() {
      _loadingGet = true;
    });

    http.get(url).then((dynamic value) {
      TestPageUtils.myDialog(
        title: '响应内容',
        content: value.toString(),
      );
    }).whenComplete(() {
      setState(() {
        _loadingGet = false;
      });
    });
  }

  Future<void> _requestPostJson() async {
    const Map<String, dynamic> data = <String, dynamic>{
      'name': 'aligator',
      'age': 25,
    };

    await http.post(
      '/path',
      data: data,
    );
  }

  Future<void> _requestPostFormData() async {
    final FormData formData = FormData.fromMap(<String, dynamic>{
      'name': 'aligator',
      'age': 25,
      // 单个文件
      'file': await MultipartFile.fromFile(
        './text.txt',
        filename: 'upload.txt',
      ),
      // 多个文件
      'files': [
        await MultipartFile.fromFile(
          './text1.txt',
          filename: 'text1.txt',
        ),
        await MultipartFile.fromFile(
          './text2.txt',
          filename: 'text2.txt',
        ),
      ],
    });

    await http.post(
      '/info',
      data: formData,
      contentType: PostContentType.formData,
    );
  }

  Future<void> _requestPostFormUrlEncoded() async {
    const Map<String, dynamic> data = <String, dynamic>{
      'name': 'aligator',
      'age': 25,
    };

    await http.post(
      '/path',
      data: data,
      contentType: PostContentType.formUrlEncoded,
    );
  }

  Future<void> _requestPut() async {
    const data = {
      'name': 'aligator',
      'age': 25,
    };

    await http.put(
      '/path',
      data: data,
    );
  }

  Future<void> _requestDelete() async {
    const data = {
      'name': 'aligator',
      'age': 25,
    };

    await http.delete(
      '/path',
      queryParameters: data,
    );
  }

  Future<void> _requestDownload() async {
    const String url =
        'http://downapp.baidu.com/baidusearch/AndroidPhone/12.6.0.10/1/757p/20201220122939/baidusearch_AndroidPhone_12-6-0-10_757p.apk?responseContentDisposition=attachment%3Bfilename%3D%22baidusearch_AndroidPhone_757p.apk%22&responseContentType=application%2Fvnd.android.package-archive&request_id=1608614044_8761566463&type=static';
    final String savePath = await PathUtils.getDefaultSavePath();
    final String filePath = '$savePath/baidusearch_AndroidPhone_12-6-0-10_757p.apk';

    setState(() {
      _loadingDownload = true;
      _downloadProgress = '0%';
      _cancelDownloadToken = CancelToken();
    });

    http.dio.download(
      url,
      filePath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          _downloadProgress = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + '%';
        });
      },
      cancelToken: _cancelDownloadToken,
      options: Options(
        receiveTimeout: 0,
      ),
    ).then((value) {
      TestPageUtils.myDialog(
        title: '下载完成',
        content: '存储路径: $filePath',
      );
    }).whenComplete(() {
      setState(() {
        _loadingDownload = false;
        _downloadProgress = null;
      });
    });
  }

  void _requestException() {
    const String url = 'https://www.google.com';

    setState(() {
      _loadingException = true;
    });

    http.get(url).then((dynamic value) {
      // do something
    }).whenComplete(() {
      setState(() {
        _loadingException = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> downloadColumnChildren = [
      ProgressButton(
        loading: _loadingDownload,
        title: '下载文件(百度app)',
        onPressed: _requestDownload,
      ),
    ];

    if (_loadingDownload) {
      downloadColumnChildren.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('下载进度: $_downloadProgress'),
          TextButton(
            child: Text('取消下载'),
            onPressed: () {
              _cancelDownloadToken.cancel();
            },
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('dio'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          columnItem(
            child: ProgressButton(
              loading: _loadingGet,
              title: 'GET 请求',
              onPressed: _requestGet,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingPostJson,
              title: 'POST 请求（json）',
              onPressed: _requestPostJson,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingPostFormData,
              title: 'POST 请求（formData）',
              onPressed: _requestPostFormData,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingPostFormUrlEncoded,
              title: 'POST 请求（formUrlEncoded）',
              onPressed: _requestPostFormUrlEncoded,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingPut,
              title: 'PUT 请求',
              onPressed: _requestPut,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingDelete,
              title: 'DELETE 请求',
              onPressed: _requestDelete,
            ),
          ),
          columnItem(
            child: Column(
              children: downloadColumnChildren,
            ),
          ),
          columnItem(
            child: ProgressButton(
              loading: _loadingException,
              title: '异常请求',
              onPressed: _requestException,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
