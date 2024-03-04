import 'package:flutter/material.dart';
import 'DriverHome.dart';

void main() {
 runApp(DriverHome());
}

class DriverRoutes extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red, // Set the primary color to red
      ),
      home: AddRoutesPage(),
    );
 }
}

class AddRoutesPage extends StatefulWidget {
 @override
 _AddRoutesPageState createState() => _AddRoutesPageState();
}

class _AddRoutesPageState extends State<AddRoutesPage> {
 final _formKey = GlobalKey<FormState>();

 String routeName = '';
 String startPoint = '';
 String endPoint = '';

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Routes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DriverHome()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                 labelText: 'Route Name',
                ),
                onChanged: (value) {
                 setState(() {
                    routeName = value;
                 });
                },
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter route name';
                 }
                 return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                 labelText: 'Start Point',
                ),
                onChanged: (value) {
                 setState(() {
                    startPoint = value;
                 });
                },
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter start point';
                 }
                 return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                 labelText: 'End Point',
                ),
                onChanged: (value) {
                 setState(() {
                    endPoint = value;
                 });
                },
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter end point';
                 }
                 return null;
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                 onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // If the form is valid, display a Snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Route added successfully')),
                      );
                    }
                 },
                 child: Text('Add Route'), // Not using const here
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }
}