import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter task 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController controller; // used to controller videos
  Future<void>
      futureController; // network takes time to load video, so to control future video data
  @override
  void initState() {
    //url to load network
    controller = VideoPlayerController.network(
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4");
    futureController = controller.initialize();
    controller.setLooping(
        true); // this will keep video looping active, means video will keep on playing
    controller.setVolume(25.0); // default  volume to initially play the video
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose(); // when app is been closed destroyed the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Video Player mp4"),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: FutureBuilder(
                future: futureController,
                builder: (context, snapshot) {
                  // if video to ready to play, else show a progress bar to the user
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            //button to play/pause the video
            RaisedButton(
              color: Colors.transparent,
              child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
            )
          ],
        ));
  }
}
