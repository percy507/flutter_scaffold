import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:myapp/config/resource.dart';
import 'package:myapp/utils/navigator_utils.dart';
import 'package:myapp/utils/screen_utils.dart';
import 'package:myapp/utils/storage_utils.dart';
import 'package:myapp/utils/database_utils.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController _countdownController;

  @override
  void initState() {
    super.initState();

    initApp();

    _countdownController = AnimationController(vsync: this, duration: Duration(seconds: 4));
    _countdownController.forward();
  }

  @override
  void dispose() {
    super.dispose();

    _countdownController.dispose();
  }

  void initApp() {
    ScreenUtils.init(NavigatorUtils.context);
    StorageUtils.init();
    DatabaseUtils.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 66),
              child: Text(
                'Hello Flutter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 36,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 110),
              child: Text(
                '启动页',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 16,
                ),
              ),
            ),
            Lottie.asset(R.turkey_warning),
            Align(
              alignment: Alignment.bottomRight,
              child: SafeArea(
                child: InkWell(
                  onTap: () {
                    NavigatorUtils.gotoHomePage();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    margin: EdgeInsets.only(right: 20, bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black.withAlpha(100),
                    ),
                    child: AnimatedCountdown(
                      animation: StepTween(begin: 5, end: 0).animate(_countdownController),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCountdown extends AnimatedWidget {
  AnimatedCountdown({Key key, this.animation}) : super(key: key, listenable: animation) {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        NavigatorUtils.gotoHomePage();
      }
    });
  }

  final Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    final int value = animation.value + 1;

    return Text(
      (value == 0 ? '' : '$value | ') + '跳过',
      style: TextStyle(color: Colors.white),
    );
  }
}

/// guide page
class GuidePage extends StatefulWidget {
  static const List<String> images = <String>[
    R.guide_page_1,
    R.guide_page_2,
    R.guide_page_3,
  ];

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        alignment: Alignment(0, 0.87),
        children: <Widget>[
          Swiper(
            itemBuilder: (ctx, index) => Image.asset(
              GuidePage.images[index],
              fit: BoxFit.fill,
            ),
            itemCount: GuidePage.images.length,
            loop: false,
            pagination: SwiperPagination(),
            onIndexChanged: (index) {
              setState(() {
                curIndex = index;
              });
            },
          ),
          Offstage(
            offstage: curIndex != GuidePage.images.length - 1,
            child: CupertinoButton(
              color: Theme.of(context).primaryColorDark,
              child: Text('点我开始'),
              onPressed: () {
                NavigatorUtils.gotoHomePage();
              },
            ),
          )
        ],
      ),
    ));
  }
}
