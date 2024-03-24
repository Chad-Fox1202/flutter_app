import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void logOut() {
    MyApp.of(context).setUser('');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    /* Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              return LoginScreen();
            })); */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
        ),
        body: Center(child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: ElevatedButton(
                    child: Text('Light Mode'),
                    onPressed: () {
                      MyApp.of(context).changeTheme(ThemeMode.light);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: ElevatedButton(
                    child: Text('Dark Mode'),
                    onPressed: () {
                      MyApp.of(context).changeTheme(ThemeMode.dark);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100,vertical: 5),
              child: ElevatedButton(
                child: Text('View Profile'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context){
                            return ProfileScreen(key: Key('profile'),title: 'profile');
                          }));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: ElevatedButton(
                child: Text('Log Out'),
                onPressed: () {
                  logOut();
                },
              ),
            ),
          ],
        )
        ));
  }
}