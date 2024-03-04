import 'package:flutter/material.dart';
import 'DriverHome.dart';
import 'mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAccount extends StatefulWidget {
  @override
  _DriverAccountState createState() => _DriverAccountState();
}

class _DriverAccountState extends State<DriverAccount> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    LoginPage(),
    SignUpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Account'),
        actions: [
          // Add the backend button to the AppBar
          // IconButton(
          //   icon: Icon(Icons.settings), // You can replace this icon
          //   onPressed: () {
          //     // Implement the functionality for the backend button here
          //     _showBackendOptions(context);
          //   },
          // ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Signup',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Function to show backend options
  void _showBackendOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Backend Options"),
          content: Text("Implement your backend functionality here."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneNumberInvalid = false;
  bool isRegistered = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.0),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(),
              ),
            ),
            if (!isRegistered)
              Text(
                '*This phone number is not valid.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Check if the phone number is registered
                String phoneNo = _phoneController.text;
                isRegistered =
                    await MongoDatabase.checkDriverPhoneNumberRegistration(
                        phoneNo);
                setState(() {});

                if (isRegistered) {
                  String name =
                      await MongoDatabase.getNameForPhoneNumber(phoneNo);
                  // Save login status to SharedPreferences
                  saveLoginStatus(true, phoneNo, name);

                  print("loggedin successfully");
                  // Phone number is registered, navigate to the main page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverHome(),
                    ),
                  );
                } else {
                  _isPhoneNumberInvalid = true;
                  print("invalid phone number");
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save login status
  Future<void> saveLoginStatus(
      bool isLoggedIn, String contactNo, String name) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('isLoggedIn: $isLoggedIn');
    print('loggedInContactNo: $contactNo');
    print('loggedInName: $name');
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('loggedInContactNo', contactNo);
    prefs.setString('loggedInName', name);
    print('isLoggedIn: $isLoggedIn');
    print('loggedInContactNo: $contactNo');
    print('loggedInName: $name');
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String phoneNo;
  bool isPhoneNumberRegistered = false;
  bool isPhoneNumberValid = true;
  bool isNameValid = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.0),
            Text(
              'Sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                name = value;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            if (!isNameValid)
              Text(
                '*Invalid Name. Your name should include alphabets and underscores only.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            TextFormField(
              onChanged: (value) {
                phoneNo = value;
              },
              decoration: InputDecoration(
                labelText: 'Phone No',
                border: OutlineInputBorder(),
              ),
            ),
            if (!isPhoneNumberValid)
              Text(
                '*This phone number is not valid.',
                style: TextStyle(color: Colors.red),
              ),
            // Display error message if phone number is already registered
            if (isPhoneNumberRegistered)
              Text(
                '*This phone number is already registered.',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Check if the phone number is already registered
                isPhoneNumberRegistered =
                    await MongoDatabase.checkPhoneNumberRegistration(phoneNo);
                setState(() {});
                isPhoneNumberValid = checkPhoneNumberValid(phoneNo);
                setState(() {});
                isNameValid = checkValidName(name);
                setState(() {});

                if (!isNameValid) {
                  print('invalid name');
                } else if (!isPhoneNumberValid) {
                  print('This phone number is not valid.');
                } else if (isPhoneNumberRegistered) {
                  // Phone number is already registered
                  // Handle this case (show an error message, etc.)
                  print('Phone number is already registered.');
                } else {
                  // Phone number is not registered, proceed with signup
                  await MongoDatabase.driverSignup(name, phoneNo);

                  // Show success dialog
                  _showSuccessDialog(context);
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

bool checkPhoneNumberValid(String phoneNo) {
  // Remove any spaces from the input
  String formattedPhoneNo = phoneNo.replaceAll(" ", "");
  RegExp pattern = RegExp(r'^\+?\d+$');

  // Check if the phone number starts with either +92 or 0
  if (formattedPhoneNo.startsWith("+92") && formattedPhoneNo.length == 13) {
    // Phone number is valid if it starts with +92 and has 13 digits
    return pattern.hasMatch(formattedPhoneNo);
  } else if (formattedPhoneNo.startsWith("03") &&
      formattedPhoneNo.length == 11) {
    // Phone number is valid if it starts with 0 and has 11 digits
    return pattern.hasMatch(formattedPhoneNo);
  } else {
    // Phone number is not valid
    return false;
  }
}

bool checkValidName(String name) {
  // Define a regular expression pattern for a valid name
  RegExp pattern = RegExp(r'^[a-zA-Z_]{2,}$');

  // Check if the name matches the pattern
  return pattern.hasMatch(name);
}

Future<void> _showSuccessDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Signup Successful"),
        content: Text("You have successfully signed up!"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog

              // Navigate to the login tab of the DriverAccount screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DriverAccount(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
