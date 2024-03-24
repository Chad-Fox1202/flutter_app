import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'video_result_screen.dart';

class VideosScreen extends StatefulWidget {

  VideosScreen({required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {

  TextEditingController controller = TextEditingController();
  String resultText = "";
  List<DocumentSnapshot> results = [];
  int numOfResults = 0;
  final videoDB = FirebaseFirestore.instance.collection('Videos');

  @override
  void initState() {
    super.initState();
  }

  void seeResults() {
    if (numOfResults > 0) {
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context){
                return VideoResultScreen(key:Key('result'),title: 'result',docs: results);
              }));
    }
  }

  Future<void> seeOtherVideos() async {
    QuerySnapshot searchResult = await videoDB.where('game',isEqualTo: 'other_videos').get();
    results = searchResult.docs;
    numOfResults = results.length;
    seeResults();
  }

  Future<void> search(String target) async {
    QuerySnapshot searchResult = await videoDB.where('game',isEqualTo: target.toLowerCase()).get();
    results = searchResult.docs;
    numOfResults = results.length;
    setState(() {
      resultText = "$numOfResults result(s) found";
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Videos'),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10),
                child: Center(child: Text("Search for videos about a game", style: Theme.of(context).textTheme.headline1,))
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                  labelText: 'Game Name',
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                  floatingLabelStyle: Theme.of(context).textTheme.bodyText2
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Search'),
                    onPressed: () {
                      search(controller.value.text);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 10),
                    child: Text(resultText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ]
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15,right: 230,top: 10),
              child: ElevatedButton(
                child: Text('See Results'),
                onPressed: () {
                  seeResults();
                },
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15,right: 230,top: 10),
              child: ElevatedButton(
                child: Text('Other Videos'),
                onPressed: () {
                  seeOtherVideos();
                },
              ),
            ),
          ],
        )
    );
  }
}