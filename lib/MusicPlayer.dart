import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter/material.dart';
import 'package:medplayer/HomePage.dart';
import 'constant.dart';
import 'AlbumArt.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

class MusicPlayer extends StatefulWidget {
  final SongInfo songInfo;
  final currentIndex;
  final length;
  final Function changeSong;
  
  MusicPlayer({this.songInfo, this.currentIndex, this.length, this.changeSong});

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  double minimumValue = 0.0;
  var maximumValue = 0.0;
  double currentValue = 0.0;
  var currentTime = '';
  var endTime = '';
  bool isPlaying = false;
  bool isRepeat = false;
  bool isShuffle = false;
  SongInfo currenSongInfo;
  SongInfo temp;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playSong();
    print('also');
    
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void playSong() async {
  
    currenSongInfo = widget.songInfo;
    await audioPlayer.setUrl(currenSongInfo.uri);
    currentValue = minimumValue;
    maximumValue = audioPlayer.duration.inMilliseconds.toDouble();
   
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    songStatus();
   
    audioPlayer.positionStream.listen((event) async {
      setState(() {
        currentValue = event.inMilliseconds.toDouble();
        currentTime = getDuration(currentValue);
      });
      if (currentValue == maximumValue) {
        isShuffle
            ? temp = await widget.changeSong(true, isShuffle)
            : isRepeat
                ? temp = currenSongInfo
                : temp = await widget.changeSong(true, isShuffle);
        setState(() {
          currentSongPlay(temp);
        });
      }
    });
  }

  void currentSongPlay(SongInfo currentSongInfo) async {
    currenSongInfo = currentSongInfo;
    await audioPlayer.setUrl(currentSongInfo.uri);
    currentValue = minimumValue;
    maximumValue = audioPlayer.duration.inMilliseconds.toDouble();
   
    currentTime = getDuration(currentValue);
    endTime = getDuration(maximumValue);
   

    audioPlayer.positionStream.listen((event) async {
      setState(() {
        currentValue = event.inMilliseconds.toDouble();
        currentTime = getDuration(currentValue);
      });
      if (currentValue == maximumValue) {
        isShuffle
            ? temp = await widget.changeSong(true, isShuffle)
            : isRepeat
                ? temp = currenSongInfo
                : temp = await widget.changeSong(true, isShuffle);
        setState(() {
          currentSongPlay(temp);
        });
      }
    });
  }

  void songStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      audioPlayer.play();
    } else {
      audioPlayer.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              1,
              0.5,
              0.7,
              0.9
            ],
            colors: [
              Color(0xF871F1A2),
              Color(0xF886F7B1),
              Color(0xF89DF1BD),
              Color(0xF8B9F1CF),
            ]),
      ),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(icon: Icon(Icons.list), onPressed: ()async{
                  
                    })
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: AlbumArts(
                  albumArt: currenSongInfo,
                ),
              ),
              Text(
                currenSongInfo.album.toString(),
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              Container(
                width: 250,
                height: 30,
                child: Marquee(
                  text: currenSongInfo.artist.toString(),
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.green,
                      fontWeight: FontWeight.w400),
                  blankSpace: 20.0,
                  velocity: 100.0,
                  pauseAfterRound: Duration(seconds: 1),
                  startPadding: 10.0,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  accelerationDuration: Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
                child: Slider(
                  value: currentValue >= maximumValue ? 0.0 : currentValue,
                  activeColor: primaryColor,
                  inactiveColor: Colors.white,
                  min: minimumValue,
                  max: maximumValue,
                  onChanged: (value) {
                    setState(() {
                      currentValue = value;
                      currentTime = getDuration(currentValue);

                      print(value.toString());
                      audioPlayer
                          .seek(Duration(milliseconds: currentValue.round()));
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentTime.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      endTime.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        isRepeat = !isRepeat;
                        if (isShuffle == true) {
                          isShuffle = false;
                        }
                      },
                      child:
                          PlayControl2(icon: Icons.repeat, isTapped: isRepeat),
                    ),
                    InkWell(
                      onTap: () async {
                        SongInfo currentSongInfo =
                            await widget.changeSong(false, isShuffle);

                        setState(() {
                          currentSongPlay(currentSongInfo);
                        });
                      },
                      splashColor: Colors.white,
                      child: PlayControl(
                        icon: Icons.skip_previous,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        songStatus();
                      },
                      splashColor: Colors.white,
                      child: PlayButton(
                        icon: isPlaying ? Icons.play_arrow : Icons.pause,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        SongInfo currentSongInfo =
                            await widget.changeSong(true, isShuffle);

                        setState(() {
                          currentSongPlay(currentSongInfo);
                        });
                      },
                      splashColor: Colors.white,
                      child: PlayControl(
                        icon: Icons.skip_next,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isShuffle = !isShuffle;
                        if (isRepeat == true) {
                          isRepeat = false;
                        }
                      },
                      child: PlayControl2(
                          icon: Icons.shuffle, isTapped: isShuffle),
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  final IconData icon;
  PlayButton({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: playControlDecoration,
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: playContorlStackdecoration1,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: playControlStackDecoration2,
              child: Center(
                child: Icon(icon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayControl extends StatelessWidget {
  final IconData icon;

  PlayControl({this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: playControlDecoration,
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: playContorlStackdecoration1,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: playControlStackDecoration2,
              child: Center(
                child: Icon(icon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayControl2 extends StatelessWidget {
  final IconData icon;
  final bool isTapped;
  PlayControl2({this.icon, this.isTapped});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: isTapped ? onTapPlayControlDecoration : playControlDecoration,
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: playContorlStackdecoration1,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: isTapped
                  ? onTapplayControlStackDecoration2
                  : playControlStackDecoration2,
              child: Center(
                child: Icon(icon),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
