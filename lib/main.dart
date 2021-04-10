import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Asignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController _videoplayercontroller;
  bool showtag = false;
  @override
  void initState() {
    super.initState();
    _videoplayercontroller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        _videoplayercontroller.play();
        setState(() {});
      });
    _videoplayercontroller.addListener(() async {
      if (_videoplayercontroller.value.isPlaying) {
        int pos = _videoplayercontroller.value.position.inMilliseconds;

        if (pos > 3000 && pos < 3500) {
          setState(() {
            showtag = true;
          });
        }
        if (pos > 3500) {
          setState(() {
            showtag = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoplayercontroller.removeListener(() {});
    _videoplayercontroller.dispose();
  }

  var showplaypuseIcon = ValueNotifier(false);
  var isplayIcon = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: Text(widget.title),
          actions: [
            IconButton(
                icon: Icon(Icons.replay),
                onPressed: () async {
                  await _videoplayercontroller.seekTo(Duration.zero);
                  setState(() {
                    _videoplayercontroller.play();
                  });
                })
          ],
        ),
        body: Stack(children: [
          _videoplayercontroller.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    showplaypuseIcon.value = true;
                    if (_videoplayercontroller.value.isPlaying) {
                      _videoplayercontroller.pause();
                      isplayIcon.value = false;
                    } else {
                      _videoplayercontroller.play();
                      isplayIcon.value = true;
                      Timer.periodic(Duration(milliseconds: 500), (timer) {
                        showplaypuseIcon.value = false;

                        timer.cancel();
                      });
                    }
                  },
                  child: VideoPlayer(_videoplayercontroller))
              : Center(child: CircularProgressIndicator()),
          showtag
              ? Positioned(
                  bottom: 100,
                  right: 80,
                  child: Column(children: [
                    Container(
                        height: 30,
                        width: 30,
                        child: CustomPaint(
                          painter: Triangle(),
                        )),
                    Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Center(
                            child: Text("Shoes",
                                style: TextStyle(color: Colors.white))))
                  ]))
              : Offstage(),
          _videoplayercontroller.value.isInitialized
              ? Center(
                  child: ValueListenableBuilder(
                      valueListenable: showplaypuseIcon,
                      builder: (context, value, child) {
                        return value
                            ? ValueListenableBuilder(
                                valueListenable: isplayIcon,
                                builder: (context, value, child) {
                                  return Icon(
                                    value ? Icons.play_arrow : Icons.pause,
                                    size: 100,
                                  );
                                },
                              )
                            : Offstage();
                      }))
              : Offstage(),
        ]));
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint()
      ..strokeWidth = 1.0
      ..color = Colors.black;
    Path path = Path();
    path.moveTo(size.width / 2, size.height * 0.25);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
