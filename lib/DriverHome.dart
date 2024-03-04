import 'package:my_app/Vehicles.dart';
import 'package:flutter/material.dart';
import 'Drivernavbar.dart';
import 'DriverRoutes.dart';
import 'Settings.dart';
import 'RateApp.dart';
import 'BreakdownIssue.dart';
import 'Stops.dart';

// void main() {
//   runApp(DriverHome());
// }

class DriverHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver View'),
      ),
      drawer: Drivernavbar(),
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
                        builder: (context) => Vehicles(),
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
                          child: Image.asset('assets/images/vehicles.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Vehicles',
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
                        builder: (context) => BreakdownIssue(),
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
                              Image.asset('assets/images/breakdown issue.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Breakdown Issue',
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
                        builder: (context) => DriverRoutes(),
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
                          'Driver Routes',
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
                        builder: (context) => Stops(),
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
                          child: Image.asset('assets/images/Location.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Stops',
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
                          child: Image.asset('assets/images/remove ads.jpeg'),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Remove Ads',
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         // Navigate to a new page here
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) => SecondPage(),
            //           ),
            //         );
            //       },
            //       child: Container(
            //         margin: EdgeInsets.only(top: 20),
            //         width: 348,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.5),
            //               spreadRadius: 5,
            //               blurRadius: 7,
            //               offset: Offset(0, 3),
            //             ),
            //           ],
            //         ),
            //         child: Column(
            //           children: [
            //             Container(
            //               width: 90,
            //               height: 70,
            //               padding: EdgeInsets.only(
            //                 left: 10.0,
            //                 right: 10.0,
            //                 top: 10.0,
            //                 bottom: 5,
            //               ),
            //               child: Image.asset('assets/images/remove ads.jpeg'),
            //             ),
            //             SizedBox(height: 5),
            //             Text(
            //               'Remove ads',
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.black,
            //               ),
            //             ),
            //             SizedBox(height: 5),
            //           ],
            //         ),
            //       ),

            //     ),
            //   ],
            // ),
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
