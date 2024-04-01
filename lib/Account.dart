import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'mongodb.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PTS',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'PTS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    LoginPage(),
    SignUpPage(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < _widgetOptions.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Sign Up',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  // final Function(String) onLogin;

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
                    await MongoDatabase.checkPhoneNumberRegistration(phoneNo);
                setState(() {});

                if (isRegistered) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                  String name =
                      await MongoDatabase.getUserNameForPhoneNumber(phoneNo);
                  saveUserLoginStatus(true, phoneNo, name);
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
  late String verificationCode;
  late TextEditingController _verificationCodeController;

  @override
  void initState() {
    super.initState();
    _verificationCodeController = TextEditingController();
    _listenForCode();
  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode;
  }

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
                  await MongoDatabase.signup(name, phoneNo);
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
              // Navigate to login screen or perform any other necessary action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'PTS'),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

Future<void> saveUserLoginStatus(
    bool isLoggedIn, String contactNo, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', isLoggedIn);
  prefs.setString('userloggedInContactNo', contactNo);
  prefs.setString('userloggedInName', name);
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
