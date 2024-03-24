import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

final databaseReference = FirebaseFirestore.instance.collection("Data");
const int searchLimit = 10; // change this to change the number of results displayed

class AdvancedSearchScreen extends StatefulWidget {

  AdvancedSearchScreen({required Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _AdvancedSearchScreen createState() => _AdvancedSearchScreen();
}

class _AdvancedSearchScreen extends State<AdvancedSearchScreen> {

  int rank = 0;
  String URL = '';
  String gameName = '';
  int minPlayers = 0;
  int maxPlayers = 0;
  int avgTime = 0;
  int year = 0;
  double rating = 0;
  String nameText = '';
  TextEditingController numInput = TextEditingController();

  List<Widget> results = [];

  // searchLimit games that allow at least num players
  Future<void> numPlayerSearch(int num) async {
    QuerySnapshot searchResult = await databaseReference
    // .where('min_players',isLessThanOrEqualTo: num) // can only have one of these for some reason
        .where('max_players',isGreaterThanOrEqualTo: num)
    // .orderBy('avg_rating') // also can't do this it turns out.
        .limit(searchLimit).get();
    List<DocumentSnapshot> resultDocs = searchResult.docs;
    results = [];
    int i = 1;
    for (var doc in resultDocs) {
      results.add(createResult(doc,i));
      i++;
    }
    setState(() {});
  }



  // searchLimit shortest games
  Future<void> ascTimeSearch() async {
    QuerySnapshot searchResult = await databaseReference
        .orderBy('avg_time').limit(searchLimit).get();
    List<DocumentSnapshot> resultDocs = searchResult.docs;
    results = [];
    int i = 1;
    for (var doc in resultDocs) {
      results.add(createResult(doc,i));
      i++;
    }
    setState(() {});
  }

  // searchLimit longest games
  Future<void> descTimeSearch() async {
    QuerySnapshot searchResult = await databaseReference
        .orderBy('avg_time',descending: true).limit(searchLimit).get();
    List<DocumentSnapshot> resultDocs = searchResult.docs;
    results = [];
    int i = 1;
    for (var doc in resultDocs) {
      results.add(createResult(doc,i));
      i++;
    }
    setState(() {});
  }

  Widget createResult(DocumentSnapshot doc, int docIndex) {

    var name = doc.get('names');
    var rankData = doc.get('rank');
    var urlData = doc.get('bgg_url');
    var minPlayersData = doc.get('min_players');
    var maxPlayersData = doc.get('max_players');
    var avgTimeData = doc.get('avg_time');
    var yearData = doc.get('year');
    var ratingData = doc.get('avg_rating');

    Future<void> _launchUrl() async {
      Uri _url = Uri.parse(urlData);
      if (!await launchUrl(_url)) {
        throw 'Could not launch $URL';
      }
    }

    return Center(
        child: RichText(
          textAlign: TextAlign.center,
        text: TextSpan(

            text: '\n\n\n',
            style: Theme.of(context).textTheme.headline1,

    children: <TextSpan>[
            const TextSpan(
            text: '\Name: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$name', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nRank: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$rankData', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nURL: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$name',
            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: new TapGestureRecognizer()
            ..onTap = () {_launchUrl();
            }
            ),
            const TextSpan(
            text: '\nYear Released: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$yearData', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nRating: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$ratingData', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nAverage Time: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$avgTimeData Minutes', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nMinimum Players: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$minPlayersData', style: TextStyle(color: Colors.brown)
            ),
            const TextSpan(
            text: '\nMaximum Players: ', style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(
            text: '$maxPlayersData', style: TextStyle(color: Colors.brown)
            ),
    ]
        ),
        ),

    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamerbase Advanced Search'),
        centerTitle: true,
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: numInput,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                        labelText: 'Number of Players',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        floatingLabelStyle: Theme.of(context).textTheme.bodyText2
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: ElevatedButton(
                      child: Text('Search'),
                      onPressed: () {
                        numPlayerSearch(int.parse(numInput.value.text));
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: ElevatedButton(
                      child: Text('View Highest Average Times'),
                      onPressed: () {
                        descTimeSearch();
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: ElevatedButton(
                      child: Text('View Lowest Average Times'),
                      onPressed: () {
                        ascTimeSearch();
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(children: results,)
                ),
              ]
          ),
        ),
      ),
    );
  }
}