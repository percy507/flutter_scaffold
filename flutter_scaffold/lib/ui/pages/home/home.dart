import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:myapp/utils/platform_utils.dart';
import 'package:myapp/ui/pages/home/tab1.dart';
import 'package:myapp/ui/pages/home/tab2.dart';
import 'package:myapp/ui/pages/home/tab3.dart';
import 'package:myapp/ui/pages/_test/index.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _bottomNavigationSelectedColor = Colors.blue;
  final _bottomNavigationUnselectedColor = Colors.black54;

  int _currentIndex = 0;

  final _pageController = PageController();
  final _pageList = <Widget>[
    Tab1Page(),
    Tab2Page(),
    Tab3Page(),
    Tab4Page(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastPopTime;

    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          showToast('再按一次返回退出');
        } else {
          lastPopTime = DateTime.now();
          PlatformUtils.quitApp();
        }
        return;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _pageList,
          // physics: NeverScrollableScrollPhysics(), // 禁止滑动页面
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: _bottomNavigationSelectedColor,
          unselectedItemColor: _bottomNavigationUnselectedColor,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xfffafafa),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: '微信',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.email,
              ),
              label: '通讯录',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '我的',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '学习',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
