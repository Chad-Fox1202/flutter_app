import 'package:flutter/material.dart';
import 'dart:math';

class UtilsScreen extends StatefulWidget {
  @override
  _UtilsScreen createState() => _UtilsScreen();
}

TextEditingController nDice = TextEditingController(text: "3");
TextEditingController nSides = TextEditingController(text: "6");

class _UtilsScreen extends State<UtilsScreen> {

  int incr = 0;
  String notes = "";
  TextEditingController notesController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Utilities'),
        centerTitle: true,
      ),
      //backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 20),
            child: Text(
              "Counter",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Text(
                    "-10",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: (){
                    incr += -10;
                    setState(() {
                      Object redrawObject = Object();
                    });
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Text(
                    "-1",
                  ),
                  onPressed: (){
                    incr += -1;
                    setState(() {
                      Object redrawObject = Object();
                    });
                  },
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  "$incr",
                ),
              ),
              //Spacer(),
              Expanded(
                child: ElevatedButton(
                  child: const Text(
                    "+1",
                  ),
                  onPressed: (){
                    incr += 1;
                    setState(() {
                      Object redrawObject = Object();
                    });
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: const Text(
                    "+10",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: (){
                    incr += 10;
                    setState(() {
                      Object redrawObject = Object();
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
            //-10, -1, Display, +1, +10
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
            child: ElevatedButton(
              child: const Text("Reset"),
              onPressed: (){
                incr = 0;
                setState(() {
                  Object redrawObject = Object();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              child: const Text("Dice Roller"),
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context){
                          return DiceRollerScreen();
                        }));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: notesController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                ),
              hintText: "Your gaming notes here",
              hintStyle: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ),
        ]
      ),
    );
  }
}

class DiceRollerScreen extends StatefulWidget {
  @override
  _DiceRollerScreen createState() => _DiceRollerScreen();
}

class _DiceRollerScreen extends State<DiceRollerScreen> {

  int nDiceInt = 3;
  int nSidesInt = 6;
  String rolled = "0";

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Roller'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 64),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Text(
                "Number Of Dice"
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
              ),
              Text(
                "Number of Sides"
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 32),
              ),
              Expanded(
                child: TextFormField(
                  controller: nDice,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 64),
              ),
              Expanded(
                child: TextFormField(
                  controller: nSides,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 32),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 8),
            child: ElevatedButton(
              child: const Text("Roll!"),
              onPressed: (){
                nDiceInt = int.parse(nDice.text);
                nSidesInt = int.parse(nSides.text);
                rolled = roller(nDiceInt, nSidesInt);
                setState(() {
                  Object redrawObject = Object();
                });
              }
            ),
         ),
         Padding(
           padding: const EdgeInsets.all(12),
           child: Text(
             "Result: $rolled",
             style: const TextStyle(
               fontSize: 24,
               fontWeight: FontWeight.bold,
             ),
           ),
         ),
        ],
      ),
    );
  }
}
  String roller(int dice, int sides) {
    int j = 0;
    if (dice > 0 && sides > 0) {
      for (int i = 0; i < dice; i += 1) {
        int temp = Random().nextInt(sides) + 1;
        //print(Random().nextInt(sides));
        j += temp;
      }
      return j.toString();
    }
    else {
      return "0";
    }
  }