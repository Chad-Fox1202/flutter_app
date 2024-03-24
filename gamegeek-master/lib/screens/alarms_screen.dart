import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';

/*****************************************************************************************************/
/*                                                                                                   */
/*   Some alarm code taken from https://www.geeksforgeeks.org/flutter-building-an-alarm-clock-app/   */
/*                                                                                                   */
/*****************************************************************************************************/


class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreen createState() => _AlarmScreen();
}

class _AlarmScreen extends State<AlarmScreen>{

  //text controllers
  TextEditingController clockController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  int hourCalc(TextEditingController controller){
    String fix = controller.text;
    List fixHour = controller.text.split(":");
    int h = int.parse(fixHour[0]);
    //print(h);
    return h;
  }

  int minuteCalc(TextEditingController controller){
    String fix = controller.text;
    List fixMin = fix.split(":");
    int min = int.parse(fixMin[1]);
    //print(min);
    return min;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Text("Game Alarms"),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              "Select your alarm time here: ",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 108, vertical: 8),
              child:TextField(
                controller: clockController,
                style: Theme.of(context).textTheme.bodyText2,//editing controller of this TextField
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).unselectedWidgetColor)),
                  icon: Icon(
                    Icons.timer,
                    color: Theme.of(context).iconTheme.color,
                  ), //icon of text field
                  labelText: "Set alarm",
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  floatingLabelStyle: Theme.of(context).textTheme.bodyText2,//label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                    TimeOfDay? pickedTime =  await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );
                  if(pickedTime != null ){
                    //print(pickedTime.format(context));   //output 10:51 PM
                    DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                    //converting to DateTime so that we can further format on different pattern.
                    //print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime = DateFormat('HH:mm').format(parsedTime);
                    //print(formattedTime); //output 14:59
                    //DateFormat() is from intl package, you can format the time on any pattern you need.
                    setState(() {
                      clockController.text = formattedTime; //set the value of text field.
                    });
                  }
                  else{
                    print("Time is not selected");
                  }
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              child: const Text(
                'Create your game alarm!',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                FlutterAlarmClock.createAlarm(hourCalc(clockController), minuteCalc(clockController));
              },
            ),
          )],
        ),
    );
  }

}