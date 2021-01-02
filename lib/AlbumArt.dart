import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'dart:io';
import 'constant.dart';


class AlbumArts extends StatelessWidget {

  final SongInfo albumArt;
  AlbumArts({this.albumArt});
  @override
  Widget build(BuildContext context) {
    print(albumArt.toString());
    return Container(
      height: 240,
      width: 270,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: albumArt.albumArtwork!=null?Image.file(File(albumArt.albumArtwork)) :Image.asset('assets/SPACE_album-mock.jpg', fit: BoxFit.fill),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.8),
            offset: Offset(20, 8),
            spreadRadius: 3,
            blurRadius: 25,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -4),
            spreadRadius: -2,
            blurRadius: 20,
          ),
        ],
      ),
    );
  }
}