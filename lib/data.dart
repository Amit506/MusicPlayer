import 'package:flutter_audio_query/flutter_audio_query.dart';

class Data {
 
  int length;
  int currentSong =3;
  final FlutterAudioQuery flutterAudioQuery = FlutterAudioQuery();
  Future getSongs() async {
    var songs = await flutterAudioQuery.getSongs();
   
    return songs;
  }
  

  






}
