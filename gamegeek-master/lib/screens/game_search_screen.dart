import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:game_geek/screens/advanced_search_screen.dart';
import 'package:url_launcher/url_launcher.dart';


final databaseReference = FirebaseFirestore.instance.collection("Data");

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {

  int rank = 0;
  String URL = '';
  String gameName = '';
  int minPlayers = 0;
  int maxPlayers = 0;
  int avgTime = 0;
  int year = 0;
  double rating = 0;
  String nameText = '';
  TextEditingController nameInput = TextEditingController();

  Future<void> setGameInfo(String name) async {
    DocumentSnapshot data =  await databaseReference.doc(name).get();
    var rankData = data.get('rank');
    var urlData = data.get('bgg_url');
    var minPlayersData = data.get('min_players');
    var maxPlayersData = data.get('max_players');
    var avgTimeData = data.get('avg_time');
    var yearData = data.get('year');
    var ratingData = data.get('avg_rating');

    setState(() {
      rank = rankData;
      URL = urlData;
      gameName = name;
      minPlayers = minPlayersData;
      maxPlayers = maxPlayersData;
      avgTime = avgTimeData;
      year = yearData;
      rating = ratingData;
    });
  }

  Future<void> _launchUrl() async {
    Uri _url = Uri.parse(URL);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $URL';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamerbase Search'),
        centerTitle: true,
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
              children:<Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: nameInput,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                        labelText: 'Game Search',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        floatingLabelStyle: Theme.of(context).textTheme.bodyText2
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child:ElevatedButton(
                      child: Text('Search'),
                      onPressed: () {
                        nameText = nameInput.text;
                        setGameInfo(nameText);
                      },
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child:ElevatedButton(
                      child: Text('Advanced Search'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AdvancedSearchScreen(title: 'Advanced Search', key: const Key("advanced search"));
                                }));
                      },
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: Theme.of(context).textTheme.headline1,

                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Name: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$gameName', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nRank: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$rank', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nURL: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$gameName',
                                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {_launchUrl();
                                  }
                            ),
                            const TextSpan(
                                text: '\nYear Released: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$year', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nRating: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$rating', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nAverage Time: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$avgTime Minutes', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nMinimum Players: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$minPlayers', style: TextStyle(color: Colors.brown)
                            ),
                            const TextSpan(
                                text: '\nMaximum Players: ', style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            TextSpan(
                                text: '$maxPlayers', style: TextStyle(color: Colors.brown)
                            ),
                          ]
                      ),
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}

// 'Name: $gameName'
// '\n\nRank: $rank'
// '\n\nURL: $URL'
// '\n\nYear Released: $year'
// '\n\nRating: $rating'
// '\n\nAverage Time: $avgTime'
// '\n\nMinimum Players: $minPlayers'
// '\n\nMaximum Players: $maxPlayers',

//textAlign: TextAlign.left,
//overflow: TextOverflow.ellipsis,
//textScaleFactor: 0.75,
//style: Theme.of(context).textTheme.headline1,