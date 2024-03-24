import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_geek/main.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {

  final userInfoDB = FirebaseFirestore.instance.collection('Users');
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String username = "";
  String password = "";
  String errorMessage = "";
  double errorMessageSize = 0.0;
  String accountCreateErrorMessage = "";
  double accountCreateErrorMessageSize = 0.0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          children: [
            // just some padding
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)
            ),
            // headline for the login page
            Text(
              "Log in to Gamerbase",
              style: Theme.of(context).textTheme.headline1,
            ),
            // horizontal rule
            Divider(
              height: 15,
              thickness: 2,
              indent: 20,
              endIndent: 20,
              color: Theme.of(context).dividerColor,
            ),
            // username input box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: usernameController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                    labelStyle: Theme.of(context).textTheme.bodyText1,
                    labelText: 'Username',
                ),
              ),
            ),
            // password input box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: passwordController,
                style: Theme.of(context).textTheme.bodyText1,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                  labelStyle: Theme.of(context).textTheme.bodyText1,
                  labelText: 'Password',
                ),
              ),
            ),
            // error message text
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: errorMessageSize),
            ),
            // login button
            ElevatedButton(
              child: const Text(
                "Login",
              ),
              onPressed: () async {
                String usernameCopy = usernameController.text;
                String passwordCopy = passwordController.text;
                if (!await passwordIsValid(usernameCopy, passwordCopy)) {
                  setErrorMessage("Username or Password is invalid!");
                }
                else {
                  setErrorMessage("");
                  MyApp.of(context).setUser(usernameCopy); // for profile page
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context){
                            return const MyHomePage(title: 'Gamerbase');
                          }));
                }
              },
            ),
            // new account button
            ElevatedButton(
              child: const Text(
                "Create New Account",
              ),
              onPressed: () {
                setErrorMessage("");
                _createNewUserDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<bool> usernameIsValid(String username) async {
    if (username.isEmpty) {
      return false;
    }
    // getting a document that doesn't exist returns an object with the "exists" property as false
    var userDocData = await userInfoDB.doc(username).get();
    if (userDocData.exists) {
      return true;
    }
    await userInfoDB.doc(username).delete();
    return false;
  }

  String hashPassword(String password) {
    var passwordBytes = utf8.encode(password);
    var hashedPassword = sha256.convert(passwordBytes);
    return hashedPassword.toString();
  }

  Future<bool> passwordIsValid(String username, String password) async {
    if (password.isEmpty || username.isEmpty || !await usernameIsValid(username)) {
      return false;
    }
    // salt password with username
    String saltedPassword = password + username;
    String hashedPassword = hashPassword(saltedPassword);
    var userDocData = await userInfoDB.doc(username).get();
    var databasePassword = userDocData.get("password");

    if (hashedPassword == databasePassword) {
      return true;
    }
    return false;
  }

  // if message is empty, then the error message text is hidden
  void setErrorMessage(String message) {
    if (message.isEmpty) {
      setState(() {
        errorMessage = "";
        errorMessageSize = 0.0;
      });
      return;
    }
    setState(() {
      errorMessage = message;
      errorMessageSize = 18.0;
    });
    return;
  }

  Future<void> _createNewUserDialog(BuildContext context) async {
    TextEditingController newUsernameController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(
            "Create new account",
            style: Theme.of(context).textTheme.headline1,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: newUsernameController,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: newPasswordController,
                    style: Theme.of(context).textTheme.bodyText1,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: confirmPasswordController,
                    style: Theme.of(context).textTheme.bodyText1,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Text(
                  accountCreateErrorMessage,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(fontSize: accountCreateErrorMessageSize),
                ),
                // login button
                ElevatedButton(
                  child: const Text(
                    "Create Account",
                  ),
                  onPressed: () async {
                    String usernameCopy = newUsernameController.text;
                    String passwordCopy = newPasswordController.text;
                    String passwordConfirmCopy = confirmPasswordController.text;
                    if (usernameCopy.isEmpty) {
                      accountCreateErrorDialog(context, "Please enter a username");
                    }
                    if (await usernameIsValid(usernameCopy)) {
                      accountCreateErrorDialog(context, "Username is taken");
                      return;
                    }
                    if (passwordCopy.isEmpty || passwordConfirmCopy.isEmpty) {
                      accountCreateErrorDialog(context, "Please enter a password");
                      return;
                    }
                    if (passwordCopy != passwordConfirmCopy) {
                      accountCreateErrorDialog(context, "Passwords must match");
                      return;
                    }
                    createNewUser(usernameCopy, passwordCopy);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> createNewUser(String username, String password) async {
    Map<String,String> newUserData = {
      "username" : username,
      "password" : hashPassword(password + username),
      "name" : "",
      "birthday" : "",
      "location" : "",
      "favorite" : "",
    };
    await userInfoDB.doc(username).set(newUserData);
    return;
  }


  Future<void> accountCreateErrorDialog(BuildContext context, String message) async {
    return showDialog<void> (
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          content: Text(
            message,
            style: Theme.of(context).textTheme.headline1,
          ),
        );
      }
    );
  }

}

