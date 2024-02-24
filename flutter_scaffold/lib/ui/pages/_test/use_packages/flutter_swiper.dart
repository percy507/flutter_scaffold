import 'package:flutter/material.dart';
import 'package:myapp/config/resource.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FlutterSwiperTest extends StatefulWidget {
  @override
  FlutterSwiperTestState createState() => FlutterSwiperTestState();
}

class FlutterSwiperTestState extends State<FlutterSwiperTest> {
  int currentIndex;

  Widget _container({@required Widget child}) {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      height: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      R.image_1,
      R.image_6,
      R.guide_page_1,
      R.guide_page_2,
      R.guide_page_3,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_swiper'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            _container(
              child: Swiper(
                itemBuilder: (ctx, index) => Image.asset(
                  images[index],
                  fit: BoxFit.fill,
                ),
                itemCount: images.length,
                loop: true,
                autoplay: true,
                pagination: SwiperPagination(),
                onIndexChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                  print(index);
                },
              ),
            ),
            _container(
              child: Swiper(
                itemBuilder: (ctx, index) => Image.asset(
                  images[index],
                  fit: BoxFit.fill,
                ),
                itemCount: images.length,
                loop: false,
                pagination: SwiperPagination(
                  builder: SwiperPagination.fraction, // default SwiperPagination.dots
                ),
              ),
            ),
            _container(
              child: Swiper(
                itemBuilder: (ctx, index) => Image.asset(
                  images[index],
                  fit: BoxFit.fill,
                ),
                itemCount: images.length,
                loop: false,
                control: SwiperControl(),
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
