import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(BreakdownIssue());
}

class BreakdownIssue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Van Breakdown'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: MyCheckboxList(),
      ),
    );
  }
}

class MyCheckboxList extends StatefulWidget {
  @override
  _MyCheckboxListState createState() => _MyCheckboxListState();
}

class _MyCheckboxListState extends State<MyCheckboxList> {
  Set<String> selectedOptions = Set<String>();

  void handleCheckbox(String option, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedOptions.add(option);
      } else {
        selectedOptions.remove(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          CheckboxRow(
            option: 'Will be Late',
            isChecked: selectedOptions.contains('Will be Late'),
            onChanged: handleCheckbox,
          ),
          CheckboxRow(
            option: 'Vehicle Issue',
            isChecked: selectedOptions.contains('Vehicle Issue'),
            onChanged: handleCheckbox,
          ),
          CheckboxRow(
            option: 'Personal Issue',
            isChecked: selectedOptions.contains('Personal Issue'),
            onChanged: handleCheckbox,
          ),
          CheckboxRow(
            option: 'Other',
            isChecked: selectedOptions.contains('Other'),
            onChanged: handleCheckbox,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              // Get phone number from shared preferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final phoneNumber = prefs.getString('loggedInContactNo') ?? '';

              // Use the obtained phone number to get the vehicle name
              final vehicleName =
                  await MongoDatabase.getVehicleNameForPhoneNumber(phoneNumber);

              // Insert issues into the database
              await MongoDatabase.insertIssuesIntoDatabase(
                  vehicleName, selectedOptions);

              print('Selected options: $selectedOptions');
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class CheckboxRow extends StatelessWidget {
  final String option;
  final bool isChecked;
  final Function(String, bool) onChanged;

  CheckboxRow({
    required this.option,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(option),
        Checkbox(
          value: isChecked,
          onChanged: (bool? newValue) {
            onChanged(option, newValue ?? false);
          },
        ),
      ],
    );
  }
}
