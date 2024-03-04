import 'package:flutter/material.dart';
import 'Navbar.dart';
import 'Routes.dart';
import 'Settings.dart';
import 'RateApp.dart';
import 'JourneyPlanner.dart';
import 'dart:async';
import 'nearby.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DriverHome.dart';

void main() async {
  runApp(FlutterApp());
}

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlutterApp",
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Delay for a smooth transition
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isLoggedIn ? DriverHome() : DashboardScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_.jpeg',
              width: 200,
              height: 200,
            ),
            Text(
              'Public Transport System',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Navbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/pic.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8, // Adjust the top position as needed
                    left: 8, // Adjust the left position as needed
                    child: Image.asset(
                      'assets/images/logo_.jpeg', // Replace 'assets/images/logo_.png' with the actual path to your image
                      width: 150, // Set the width to your desired value
                      height: 50, // Set the height to your desired value
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Nearby(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child: Image.asset('assets/images/nearby.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Nearby',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SecondPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child:
                              Image.asset('assets/images/favourites (2).jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Favourites',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Routes(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child: Image.asset('assets/images/routes.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Routes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => JourneyPlanner(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child:
                              Image.asset('assets/images/journey planner.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Journey Planner',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Settings(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child: Image.asset('assets/images/settings.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RateApp(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child:
                              Image.asset('assets/images/rate this app.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rate this app',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to a new page here
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SecondPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 348,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 70,
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 5,
                          ),
                          child: Image.asset('assets/images/remove ads.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Remove ads',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text('This is the second page.'),
      ),
    );
  }
}
