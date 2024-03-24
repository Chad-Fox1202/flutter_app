import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoResultScreen extends StatefulWidget {

  VideoResultScreen({required Key? key, required this.title, required List<DocumentSnapshot> docs}) : super(key: key) {
    videoDocs = docs;
  }
  final String title;
  List<DocumentSnapshot> videoDocs = [];

  @override
  _VideoResultScreenState createState() => _VideoResultScreenState(docs: videoDocs);
}

class _VideoResultScreenState extends State<VideoResultScreen> {

  List<DocumentSnapshot> videoDocs = [];

  _VideoResultScreenState({required List<DocumentSnapshot> docs}) {
    videoDocs = docs;
  }

  YoutubePlayerController createController(String id) {
    return YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  Widget createPlayer(String id, String title) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(title,
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        YoutubePlayer(
          controller: createController(id),
          showVideoProgressIndicator: true,
        ),
      ],
    );
  }

  List<Widget> createPlayerList() {
    List<Widget> players = [];
    for (var doc in videoDocs) {
      players.add(createPlayer(doc.get('id'), doc.get('title')));
    }
    return players;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Videos'),
          centerTitle: true,
        ),
        body: ListView(
          children: createPlayerList()
        )
    );
  }
}