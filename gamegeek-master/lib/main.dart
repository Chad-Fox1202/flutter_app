import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_geek/screens/alarms_screen.dart';
import 'package:game_geek/screens/game_timer_page.dart';
import 'package:game_geek/screens/game_utils_screen.dart';
import 'package:game_geek/screens/login_screen.dart';
import 'package:game_geek/screens/game_search_screen.dart';
import 'package:game_geek/screens/settings_screen.dart';
import 'package:game_geek/screens/videos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.system;
  String user = "exampleUsername"; // username of currently logged in user

  void changeTheme(ThemeMode newMode) {
    setState(() {
      _themeMode = newMode;
    });
  }

  // get logged in user
  String getUser() {
    return user;
  }

  // change logged in user e.g. MyApp.of(context).setUser('exampleUsername');
  void setUser(String newUser) {
    user = newUser;
  }

  @override
  void initState() {
    super.initState();
    setUser('exampleUsername');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("couldnt connect");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Gamerbase',
                theme: ThemeData(
                  iconTheme: const IconThemeData(
                      color: Colors.brown,
                  ),
                  unselectedWidgetColor: Colors.brown,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.brown,
                  ),
                  scaffoldBackgroundColor: const Color.fromRGBO(210, 180, 140, 1),
                  secondaryHeaderColor: const Color.fromRGBO(237, 225, 209, 1),
                  dividerColor: Colors.black,
                  textTheme: const TextTheme(
                    bodyText1: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    bodyText2: TextStyle(
                        color: Colors.brown,
                        fontSize: 18
                    ),
                    subtitle2: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    headline1: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                    headline2: TextStyle(
                        color: Colors.brown,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                    headline3: TextStyle(
                        color: Colors.brown,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                    ),
                    headline5: TextStyle(  //using headline5 as drawer buttons because button has already been defined and it messes up a lot of things
                      shadows: [
                        Shadow(
                            color: Colors.brown,
                            offset: Offset(0, -5))
                      ],
                        color: Colors.transparent,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.brown,
                        decorationThickness: 2,
                    ),
                    button: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  canvasColor: const Color.fromRGBO(228, 210, 186, 1),
                ),
                darkTheme: ThemeData(
                  iconTheme: IconThemeData(
                      color: Colors.brown.shade100,
                  ),
                  unselectedWidgetColor: Colors.brown.shade100,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.brown,
                  ),
                  scaffoldBackgroundColor: Colors.brown.shade900,
                  secondaryHeaderColor: const Color.fromRGBO(100, 82, 78, 1),
                  dividerColor: Colors.grey.shade400,
                    canvasColor: Colors.brown.shade900,
                    textTheme:  TextTheme(
                      bodyText1: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18
                      ),
                      bodyText2: TextStyle(
                          color: Colors.brown.shade100,
                          fontSize: 18
                      ),
                      subtitle2: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      headline1: TextStyle(
                          color: Colors.brown.shade100,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                      headline3: TextStyle(
                        color: Colors.brown.shade100,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      headline5: TextStyle(
                        shadows: [
                          Shadow(
                              color: Colors.brown.shade100,
                              offset: Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.brown.shade100,
                        decorationThickness: 2,
                      ),
                      button: TextStyle(
                          fontSize: 18
                      ),
                    ),
                ),
                themeMode: _themeMode,
                home: const LoginScreen(),
                // home: const MyHomePage(title: 'Gamerbase'),
            );
          }
          Widget loading = MaterialApp();
          return loading;
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/checkered.jpg"), //background img
                fit: BoxFit.cover,
                ),
              ),
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Text('Gamerbase'),
              ),
            ),
            body: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32, left: 64, right: 52),
                  child: Stack(
                    children: <Widget>[
                      // Stroked text as border.
                      Text(
                        'Welcome To Gamerbase!',
                        style: TextStyle(
                          fontSize: 48,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = const Color.fromARGB(70, 255, 255, 255),
                        ),
                      ),
                      // Solid text as fill.
                      const Text(
                        'Welcome To Gamerbase!',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  )
                ),
                Container(
                  height: 500,
                  width: 800,
                  alignment: Alignment.center,
                  child:
                  Image.asset('assets/img/queen.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            drawer: HamburgerDir(),
          )
       ]
    );
  }
}

class HamburgerDir extends StatelessWidget {

  // method for flutter data binding taken from: https://medium.com/flutter-community/data-binding-in-flutter-or-passing-data-from-a-child-widget-to-a-parent-widget-4b1c5ffe2114

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Game Alarm',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context){
                      return AlarmScreen();
                    }));
            }
          ),
          ListTile(
              title: Text('Game Search',
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context){
                          return SearchScreen();
                        }));
              },
          ),
          ListTile(
            title: Text('Videos',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context){
                        return VideosScreen(key:Key('videos'),title: 'videos',);
                      }));
            },
          ),
          ListTile(
            title: Text('Game Timer',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap:(){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context){
                        return TimerScreen();
                      }));
            },
          ),
          ListTile(
            title: Text('Game Utilities',
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context){
                        return UtilsScreen();
                      }));
            },
          ),
          ListTile(
            title: Text('Settings',
                style: Theme
                    .of(context)
                    .textTheme
                    .headline5
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SettingsScreen(title: 'settings', key: Key("settings"));
                      }));
            },
          ),
        ],
      ),
    );
  }
}