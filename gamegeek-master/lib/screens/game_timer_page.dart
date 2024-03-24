import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreen createState() => _TimerScreen();
}

class _TimerScreen extends State<TimerScreen> {

  TextEditingController nameInput = TextEditingController();
  String gameName = '';
  String formattedDate = new DateFormat('LLL d, yyyy').format(new DateTime.now());
  String formattedTime = new DateFormat('kk:mm:ss').format(new DateTime.now());
  Stopwatch stopwatch = Stopwatch();
  late Timer _timer;

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

    @override
    void initState() {
      super.initState();
      // re-render every 30ms
      _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
        setState(() {});
      });
    }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Timer'),
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
                        labelText: 'Game Name',
                        labelStyle: Theme.of(context).textTheme.bodyText1,
                        floatingLabelStyle: Theme.of(context).textTheme.bodyText2
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child:ElevatedButton(
                      child: Text('Set'),
                      onPressed: () {
                        setState(() {
                          gameName = nameInput.text;
                        });
                      },
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2),
                  child: Center(
                    child: Text(
                      'Name: $gameName'
                          '\nGame Start Date: $formattedDate'
                      '\nGame Start Time: $formattedTime'
                      '\n\nStopwatch:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: Center(
                    child: Text(
                      formatTime(stopwatch.elapsedMilliseconds),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child:ElevatedButton(
                          child: Text('Start'),
                          onPressed: () {
                            stopwatch.start();
                            if(formatTime(stopwatch.elapsedMilliseconds) == "00:00:00") {
                              setState(() {
                                formattedTime = new DateFormat('kk:mm:ss').format(new DateTime.now());
                                formattedDate = new DateFormat('LLL d, yyyy').format(new DateTime.now());
                              });
                            }
                          },
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child:ElevatedButton(
                          child: Text('Stop'),
                          onPressed: () {
                            setState(() {
                              if(stopwatch.isRunning) {
                                stopwatch.stop();
                              }
                            });
                          },
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child:ElevatedButton(
                          child: Text('Reset'),
                          onPressed: () {
                            setState(() {
                              if(stopwatch.isRunning) {
                                stopwatch.stop();
                                stopwatch.reset();
                              }
                              else {
                                stopwatch.reset();
                              }
                            });
                          },
                        )
                    ),
                  ],
                )
                  ],
                ),
              ),
          ),
    );
  }
}