import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
 runApp(RateApp());
}

class RateApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red, // Set the app bar background color to red
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Rate this app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'If you like this app, please rate it:',
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red), // Set the button background color to red
                ),
                onPressed: () async {
                  const url = 'https://www.google.com/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('Rate this app'),
              ),

            ],
          ),
        ),

      ),
    );
 }
}