import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'data.dart';
import 'MusicPlayer.dart';
import 'dart:math';
import 'dart:io';
import 'package:just_audio/just_audio.dart';

enum PlayerState { stopped, playing, paused }

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animateController;
  Data songsData = Data();
  List<SongInfo> _songs;
  int changedIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  bool isSong = true;
  bool isAnimationCompleted = true;
 

  @override
  void initState() {
    super.initState();
    animateController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..forward()..addStatusListener((status) {
        if(status ==AnimationStatus.completed){
         
        
        setState(() {
            isAnimationCompleted=false;
        });
          
        }
    });

    gotSongs();
  }

  @override
  void dispose() {
    super.dispose();
    animateController.dispose();
  }

  void gotSongs() async {
    var songs = await songsData.getSongs();
    setState(() {
      _songs = songs;
      isSong = false;
    });
  }

  SongInfo changeSong(bool isNext, bool isShuffle) {
    if (isShuffle) {
      final random = Random();
      int shuffledIndex = random.nextInt(_songs.length);
      return _songs[shuffledIndex];
    } else {
      if (isNext) {
        if (changedIndex != _songs.length - 1) {
          changedIndex++;
          
          return _songs[changedIndex];
        } else {
          return _songs[changedIndex];
        }
      } else {
        if (changedIndex > 0) {
          
          changedIndex--;
          
          return _songs[changedIndex];
        } else {
          return _songs[changedIndex];
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return isAnimationCompleted
        ? Scaffold(
            body: Container(
              color: Color(0xF8BEECD0),
            child: Center(
                child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0)
                  .animate(animateController),
              child: Container(
                child: Image.asset('assets/f8a7b6e4-6564-4094-b027-357b0dcef705_200x200.png'),
              ),
            ),
            
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              leading: Image.asset('assets/f8a7b6e4-6564-4094-b027-357b0dcef705_200x200.png'),
              backgroundColor: Color(0xFF0A2E07),
              title: Text('Lit player',style: TextStyle(letterSpacing: 2,wordSpacing: 5,fontFamily: 'serif',fontWeight: FontWeight.w800
              
              ),),
            ),
            body: isSong
                ? Container(
                    child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                  ))
                : ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: _songs[index].albumArtwork != null
                              ? FileImage(File(_songs[index].albumArtwork))
                              : AssetImage(
                                  'assets/SPACE_album-mock.jpg',
                                ),
                        ),
                        selectedTileColor: Color(0xF8A5EBC0),
                        title: Text(_songs[index].title),
                        subtitle: Text(_songs[index].artist),
                        onTap: () {
                          changedIndex = index;
                          print(songsData.currentSong.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MusicPlayer(
                                        songInfo: _songs[index],
                                        currentIndex: index,
                                        changeSong: changeSong,
                                        length: _songs.length,
                                      
                                      )));
                        },
                      );
                    },
                  ));
  }
}
