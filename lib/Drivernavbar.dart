import 'package:flutter/material.dart';
import 'package:my_app/Stops.dart';
import 'Settings.dart';
import 'Routes.dart';
import 'main.dart';
import 'DriverAccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drivernavbar extends StatefulWidget {
  @override
  _DrivernavbarState createState() => _DrivernavbarState();
}

class _DrivernavbarState extends State<Drivernavbar> {
  late String loggedInName = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    loadLoggedInName();
  }

  Future<void> loadLoggedInName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('loggedInName') ?? '';
    setState(() {
      loggedInName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder(
            future: loadLoggedInName(),
            builder: (context, snapshot) {
              return UserAccountsDrawerHeader(
                accountName: loggedInName.isNotEmpty ? Text('') : null,
                accountEmail: Text(''),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/navpic.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Welcome, $loggedInName!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Image.asset(
              'assets/images/van grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Vehicles'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/breakdown grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Breakdown Issue'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/rate app grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Rate this app'),
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/remove ad grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Remove ads'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/routes grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Driver Routes'),
            onTap: () => null,
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/location grey.jpeg',
              width: 30,
              height: 30,
            ),
            title: Text('Stops'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Stops(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            // tileColor: Colors.red,
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              prefs.remove('loggedInContactNo');
              prefs.remove('loggedInName');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      DriverAccount(), // Replace LoginScreen with your actual login screen widget
                ),
                (route) => false, // Remove all previous routes from the stack
              );
            },
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.drive_eta),
            title: Text(
              'User View',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            tileColor: Colors.red,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(),
                ),
              );
            },
          ),
          // if (loggedInName.isNotEmpty)
        ],
      ),
    );
  }
}

class HoverableRoutesButton extends StatefulWidget {
  final IconData icon;
  final String label;

  const HoverableRoutesButton({
    required this.icon,
    required this.label,
  });

  @override
  _HoverableRoutesButtonState createState() => _HoverableRoutesButtonState();
}

class _HoverableRoutesButtonState extends State<HoverableRoutesButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
        },
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Routes()));
          },
          child: Container(
            color: isHovered ? Colors.blue : Colors.transparent,
            child: Column(
              children: [
                Icon(
                  widget.icon,
                  color: Colors.grey[700],
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
