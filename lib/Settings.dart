import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/nearby.dart';
import 'Account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Notifications.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showCountdown = false;
  String selectedValue = 'home';
  double autoRefreshInterval = 0.0;
  double autoRadius = 0.0; // Initialize with 0 seconds
  bool isLoggedIn = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all SharedPreferences data
    // Redirect to the home screen or another appropriate screen after sign out
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) =>
            DashboardScreen(), // Replace with your home screen
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
      userName = prefs.getString('userloggedInName') ?? '';
    });
  }

  String _getLabelText(double value) {
    if (value == 0.0) {
      return "Never";
    } else {
      return value.round().toString() + ' seconds';
    }
  }

  String _getRadiusText(double value) {
    if (value == 1000.0) {
      return "1 km";
    } else {
      return value.round().toString() + ' m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Starting Screen',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedValue,
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: 'home',
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.home,
                                color: Colors.red, // Set the color to red
                              ),
                              margin: EdgeInsets.only(
                                  right: 8.0), // Add margin for spacing
                            ),
                            Text('Home'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'favourites',
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red, // Set the color to red
                              ),
                              margin: EdgeInsets.only(
                                  right: 8.0), // Add margin for spacing
                            ),
                            Text('Favourites'),
                          ],
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: 'nearby',
                        child: Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red, // Set the color to red
                              ),
                              margin: EdgeInsets.only(
                                  right: 8.0), // Add margin for spacing
                            ),
                            Text('Nearby'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Countdown behaviour',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Show countdown in 15-second intervals\n',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'If a bus is less than 2 minutes away, then display the remaining time in seconds',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: showCountdown,
                        onChanged: (newValue) {
                          setState(() {
                            showCountdown = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Auto-refresh interval\n',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'How often should the app check for updates to bus times. Suggested value is 15 seconds.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 12.0), // Adjust the margin as needed
                        child: Text(
                          _getLabelText(
                              autoRefreshInterval), // Display the selected value
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SliderExample(
                    onChanged: (value) {
                      setState(() {
                        autoRefreshInterval = value;
                      });
                    },
                  ),
                  Divider(),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nearby stops distancel\n',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'This is the radius from the curent location to look for nearby stops.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 12.0), // Adjust the margin as needed
                        child: Text(
                          _getRadiusText(
                              autoRadius), // Display the selected value
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  RadiusSlider(
                    onChanged: (value) {
                      setState(() {
                        autoRadius = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                if (isLoggedIn) {
                  // User is currently logged in, perform sign out
                  await _signOut();
                } else {
                  // User is not logged in, navigate to the sign-in page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Account(), // Replace with your sign-in screen
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -2),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: isLoggedIn ? 'Sign Out\n' : 'Sign In\n',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: isLoggedIn
                                      ? 'Sign out to clear your settings and favorites.'
                                      : 'Sign in to save your settings and favorites to the cloud or restore them to a different device.',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 7.0), // Add left margin here
                          child: Icon(
                            isLoggedIn
                                ? Icons.exit_to_app
                                : Icons.person_outline,
                            size: 30.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    isLoggedIn
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '$userName',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Other Services',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Location Services\n',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'To enable or disable location services, you need to do this in the application settings. Tap here to go now.',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 7.0), // Add left margin here
                            child: Icon(
                              Icons.location_on,
                              size: 30.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RichText(
                  //         text: TextSpan(
                  //           children: [
                  //             TextSpan(
                  //               text: 'Enthusiast mode\n',
                  //               style: TextStyle(
                  //                 fontSize: 16.0,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //             TextSpan(
                  //               text:
                  //                   'Adds additional functionality for bus enthusiasts - this is experimental. It may either break or it may become a paid service in future',
                  //               style: TextStyle(
                  //                 fontSize: 14.0,
                  //                 color: Colors.grey[600],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     Checkbox(
                  //       value: showCountdown,
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           showCountdown = newValue!;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 8),
                  // Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Use Android location provider\n',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text:
                                    'The defult is off. Try to change this if your phone has problem with GPS connectivity.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: showCountdown,
                        onChanged: (newValue) {
                          setState(() {
                            showCountdown = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifications(),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white, // Background color
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                              width: 16), // Add space between icon and text
                          Text(
                            'Notifications',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Public Transport System"),
                            content: Text("Version: 1.0"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      color: Colors.white, // Background color
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_bus,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                              width: 16), // Add space between icon and text
                          Text(
                            'About Public Transport System',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SliderExample extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const SliderExample({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentValue = 0.0; // Initial value (0 seconds)

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: 0.0, // Minimum value (0 seconds)
      max: 60.0, // Maximum value (60 seconds)
      divisions: 12, // Divided into 12 intervals (12 steps from 0 to 60)
      label: _getLabelText(_currentValue),
      onChanged: (double value) {
        setState(() {
          _currentValue = value;
        });
        widget.onChanged(value); // Pass the selected value to the parent widget
      },
    );
  }

  String _getLabelText(double value) {
    if (value == 0.0) {
      return "Never";
    } else {
      return value.round().toString() + ' seconds';
    }
  }
}

class RadiusSlider extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const RadiusSlider({Key? key, required this.onChanged}) : super(key: key);

  @override
  _RadiusSliderState createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  double _currentValue = 0.0; // Initial value (0 seconds)

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: 0.0, // Minimum value (0 seconds)
      max: 1000.0, // Maximum value (60 seconds)
      divisions: 1000, // Divided into 12 intervals (12 steps from 0 to 60)
      label: _getRadiusText(_currentValue),
      onChanged: (double value) {
        setState(() {
          _currentValue = value;
        });
        widget.onChanged(value); // Pass the selected value to the parent widget
      },
    );
  }

  String _getRadiusText(double value) {
    if (value == 1000.0) {
      return "1 km";
    } else {
      return value.round().toString() + ' m';
    }
  }
}
