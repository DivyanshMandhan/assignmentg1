import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_hub/data/data.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class ShortsScreen extends StatefulWidget {
  static const String id = 'ShortsScreen';

  const ShortsScreen({Key? key}) : super(key: key);
  @override
  _ShortsScreenState createState() => _ShortsScreenState();
}

VideoData videoData = VideoData();

class _ShortsScreenState extends State<ShortsScreen> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videoData.shortsList.length,
            itemBuilder: (context, index) {
              return ShortsList(
                name: videoData.shortsList.values.elementAt(index).elementAt(0),
                profilePic:
                    videoData.shortsList.values.elementAt(index).elementAt(1),
                vid: videoData.shortsList.values.elementAt(index).elementAt(2),
                caption:
                    videoData.shortsList.values.elementAt(index).elementAt(3),
                image:
                    videoData.shortsList.values.elementAt(index).elementAt(4),
              );
            }),
      ),
    );
  }
}

// ignore: must_be_immutable
class ShortsList extends StatefulWidget {
  final String vid;
  String name;
  String profilePic;
  String caption;
  String image;
  ShortsList(
      {Key? key,
      required this.name,
      required this.caption,
      required this.vid,
      required this.profilePic,
      required this.image})
      : super(key: key);

  @override
  _ShortsListState createState() => _ShortsListState();
}

class _ShortsListState extends State<ShortsList> {
  late VideoPlayerController _videoController;
  bool _isMuted = false;
  late String url = "";
  @override
  void initState() {
    super.initState();
    _videoController =
        _videoController = VideoPlayerController.network(widget.vid)
          ..initialize().then((_) => setState(() {}))
          ..setVolume(1)
          ..play();
    _videoController.setLooping(true);

    setPortrait();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: _videoController.value.isInitialized
              ? VideoPlayer(_videoController)
              : Image.asset(
                  widget.image,
                  fit: BoxFit.cover,
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 25.0, left: 15.0, right: 15, bottom: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.79,
              ),
              Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: w * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.caption,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 12.5,
                                    backgroundImage:
                                        AssetImage(widget.profilePic),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (_videoController.value.isInitialized)
                        IconButton(
                          icon: Icon(
                            _isMuted ? Icons.volume_off : Icons.volume_up,
                          ),
                          color: Colors.white,
                          iconSize: 30.0,
                          onPressed: () => setState(() {
                            _isMuted
                                ? _videoController.setVolume(1)
                                : _videoController.setVolume(0);
                            _isMuted = _videoController.value.volume == 0;
                          }),
                        ),
                      Container(
                        height: 36,
                        width: 36,
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                height: 32,
                                width: 32,
                                child: Image.asset(
                                  'assets/music_bar.gif',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Future setPortrait() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}
