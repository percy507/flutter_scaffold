import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/_test/test_page_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/config/resource.dart';

class LottieTest extends StatefulWidget {
  @override
  LottieTestState createState() => LottieTestState();
}

class LottieTestState extends State<LottieTest> with TickerProviderStateMixin {
  AnimationController _controller;
  Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  Future<LottieComposition> _loadComposition() async {
    final assetData = await DefaultAssetBundle.of(context).load(R.turkey_warning);
    return await LottieComposition.fromByteData(assetData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lottie'),
      ),
      body: ListView(
        children: [
          // Load an animation and its images from a zip file
          Lottie.asset(
            R.turkey_warning,
            height: 200,
            fit: BoxFit.contain,
            controller: _controller,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
          FutureBuilder<LottieComposition>(
            future: _composition,
            builder: (context, snapshot) {
              final composition = snapshot.data;
              if (composition != null) {
                return Lottie(
                  composition: composition,
                  height: 200,
                );
              } else {
                return TestPageUtils.myButton(
                  title: '手动加载动画',
                  onPressed: () {
                    _composition = _loadComposition();
                    setState(() {});
                  },
                );
              }
            },
          ),
          // Load a Lottie file from your assets
          Lottie.asset(
            R.turkey_warning,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          // Load a Lottie file from a remote url
          Lottie.network(
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
