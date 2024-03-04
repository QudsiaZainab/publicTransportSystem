import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static insertRoutes() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(ROUTES_COLLECTION_NAME);
    await collection.insertOne({
      "email": "email",
      "password": "password",
    });
    print(await collection.find().toList());
  }

  static Future<String> getNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      final collection = db.collection(DRIVER_COLLECTION_NAME);

      // Search for a document with the provided phone number
      final document =
          await collection.findOne(where.eq('phone_no', phoneNumber));

      await db.close();

      // If the document is found, return the associated name, otherwise return a default value (empty string in this case)
      return document?['name'] as String;
    } catch (e) {
      print('Error getting name for phone number: $e');
      return ''; // Handle the error as needed or provide a default value
    }
  }

  static Future<String> getUserNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      final collection = db.collection('public_users');

      // Search for a document with the provided phone number
      final document =
          await collection.findOne(where.eq('phone_no', phoneNumber));

      await db.close();

      // If the document is found, return the associated name, otherwise return a default value (empty string in this case)
      return document?['name'] as String;
    } catch (e) {
      print('Error getting name for phone number: $e');
      return ''; // Handle the error as needed or provide a default value
    }
  }

  static driverSignup(String name, String phoneNo) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(DRIVER_COLLECTION_NAME);
    if (phoneNo.startsWith("+92")) {
      phoneNo = phoneNo.replaceFirst("+92", "0");
    }
    await collection.insertOne({
      "name": name,
      "phone_no": phoneNo,
    });
    print(await collection.find().toList());
  }

  static signup(String name, String phoneNo) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    var collection = db.collection(COLLECTION_NAME);
    if (phoneNo.startsWith("+92")) {
      phoneNo = phoneNo.replaceFirst("+92", "0");
    }
    await collection.insertOne({
      "name": name,
      "phone_no": phoneNo,
    });
    print(await collection.find().toList());
  }

  static Future<bool> checkPhoneNumberRegistration(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      // Search for a document with the provided phone number
      final count = await db
          .collection('drivers')
          .count(where.eq('phone_no', phoneNumber));

      await db.close();

      // If count is greater than 0, phone number is already registered
      return count > 0;
    } catch (e) {
      print('Error checking phone number registration: $e');
      return false; // Handle the error as needed
    }
  }

  static Future<bool> checkDriverPhoneNumberRegistration(
      String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      if (phoneNumber.startsWith("+92")) {
        phoneNumber = phoneNumber.replaceFirst("+92", "0");
      }

      // Search for a document with the provided phone number
      final count = await db
          .collection(DRIVER_COLLECTION_NAME)
          .count(where.eq('phone_no', phoneNumber));

      await db.close();

      // If count is greater than 0, phone number is already registered
      return count > 0;
    } catch (e) {
      print('Error checking phone number registration: $e');
      return false; // Handle the error as needed
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      // Replace 'your_collection_name' with the actual name of your collection
      final collection = db.collection('routes');

      // Fetch all documents in the collection
      final List<Map<String, dynamic>> data = await collection.find().toList();

      await db.close();
      print(data);
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Handle the error as needed
    }
  }

  static Future<String> getVanNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driverCollection = db.collection('drivers');

      // Search for a document with the provided phone number
      final driverDocument =
          await driverCollection.findOne(where.eq('phone_no', phoneNumber));

      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Fetch van name based on driver ID from the associated collection
        final vanRouteCollection = db.collection('routes');
        final vanDocument =
            await vanRouteCollection.findOne(where.eq('driver', driverId));
        // print(vanDocument);

        if (vanDocument != null) {
          return vanDocument['vehicleNo'] as String;
        }
      }

      await db.close();
      return ''; // Return empty string if not found
    } catch (e) {
      print('Error getting van name for phone number: $e');
      return ''; // Handle the error as needed
    }
  }

  static Future<String> getRouteNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driverCollection = db.collection('drivers');

      // Search for a document with the provided phone number
      final driverDocument =
          await driverCollection.findOne(where.eq('phone_no', phoneNumber));
      // print(driverDocument);

      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Fetch route name based on driver ID from the associated collection
        final vanRouteCollection = db.collection('routes');
        final routeDocument =
            await vanRouteCollection.findOne(where.eq('driver', driverId));

        if (routeDocument != null) {
          return routeDocument['route_name'] as String;
        }
      }

      await db.close();
      return ''; // Return empty string if not found
    } catch (e) {
      print('Error getting route name for phone number: $e');
      return ''; // Handle the error as needed
    }
  }

  static Future<void> addVehicle(String vehicleName, String driverContactNo,
      double latitude, double longitude) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final vehiclesCollection = db.collection('vehicles');

      // Insert vehicle information into the collection
      await vehiclesCollection.insertOne({
        'vehicle_name': vehicleName,
        'driver_contact_no': driverContactNo,
        'location': {
          'type': 'Point',
          'coordinates': [longitude, latitude]
        },
      });

      await db.close();
    } catch (e) {
      print('Error adding vehicle: $e');
      // Handle the error as needed
    }
  }

  static Future<void> updateDriverLocation(
    String driverContactNo,
    double latitude,
    double longitude,
  ) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final driversCollection = db.collection(DRIVER_COLLECTION_NAME);

      // Find the driver document with the provided phone number
      final driverDocument = await driversCollection
          .findOne(where.eq('phone_no', driverContactNo));

      if (driverDocument != null) {
        // Driver found, get driver ID
        final driverId = driverDocument['phone_no'];

        // Update the driver's location in the drivers collection
        await driversCollection.update(
          where.eq('phone_no', driverContactNo),
          modify.set('location', {
            'type': 'Point',
            'coordinates': [longitude, latitude]
          }),
        );

        // Print or handle success if needed
        print('Driver location updated successfully');
      } else {
        print('Driver not found with phone number: $driverContactNo');
      }

      await db.close();
    } catch (e) {
      print('Error updating driver location: $e');
      // Handle the error as needed
    }
  }

  static Future<String> getVehicleNameForPhoneNumber(String phoneNumber) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final collection = db.collection('vehicles');

      // Search for a document with the provided phone number
      final document = await collection.findOne(
        where.eq('driver_contact_no', phoneNumber),
      );

      await db.close();

      // If the document is found, return the associated vehicle name, otherwise return a default value (empty string in this case)
      return document?['vehicle_name'] as String;
    } catch (e) {
      print('Error getting vehicle name for phone number: $e');
      return ''; // Handle the error as needed or provide a default value
    }
  }

  static Future<String> getArrivalTimeForVan(String vanName) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final routesCollection = db.collection('routes');

      // Fetch the route document based on the van name
      final routeDocument =
          await routesCollection.findOne(where.eq('vehicleNo', vanName));

      if (routeDocument != null) {
        // Calculate arrival time based on the route information (location, etc.)
        final lastUpdateTime = routeDocument['lastUpdateTime'] as DateTime;

        // Calculate arrival time, for example, add 30 minutes to the last update time
        final arrivalTime = lastUpdateTime.add(Duration(minutes: 30));

        await db.close();
        return arrivalTime.toString();
      }

      await db.close();
      return ''; // Return empty string if not found
    } catch (e) {
      print('Error getting arrival time for van: $e');
      return ''; // Handle the error as needed
    }
  }

  static Future<Map<String, double>> getVehicleLocation(String vanName) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final vehiclesCollection = db.collection('vehicles');

      // Fetch the vehicle document based on the van name
      final vehicleDocument =
          await vehiclesCollection.findOne(where.eq('vehicle_name', vanName));

      await db.close();

      if (vehicleDocument != null) {
        // Extract location coordinates from the vehicle document
        final location = vehicleDocument['location'] as Map<String, dynamic>?;

        if (location != null) {
          final List<dynamic> coordinates = location['coordinates'];

          // Extract latitude and longitude from coordinates
          final double latitude = coordinates[1] as double;
          final double longitude = coordinates[0] as double;

          return {'latitude': latitude, 'longitude': longitude};
        }
      }

      return {}; // Return empty map if not found or location is null
    } catch (e) {
      print('Error getting vehicle location: $e');
      return {}; // Handle the error as needed
    }
  }

  static Future<List<Map<String, dynamic>>> getStopsData() async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      // Replace 'your_collection_name' with the actual name of your collection
      final collection = db.collection('stops');

      // Fetch all documents in the collection
      final List<Map<String, dynamic>> data = await collection.find().toList();

      await db.close();
      print(data);
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Handle the error as needed
    }
  }

  static Future<void> addNewStop(
      String stopName, double latitude, double longitude) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      // Replace 'your_collection_name' with the actual name of your collection
      final collection = db.collection('stops');

      // Insert the new stop information into the collection
      await collection.insert({
        'stop_name': stopName,
        'latitude': latitude,
        'longitude': longitude,
      });

      await db.close();
    } catch (e) {
      print('Error adding new stop: $e');
      // Handle the error as needed
    }
  }

  static Future<void> insertIssuesIntoDatabase(
      String vehicleName, Set<String> selectedOptions) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final collection = db.collection('breakdown_issues');

      for (String issue in selectedOptions) {
        await collection.insertOne({
          'vehicle_name': vehicleName,
          'issue': issue,
          'timestamp': DateTime.now(),
        });
      }

      await db.close();
    } catch (e) {
      print('Error inserting issues into the database: $e');
      // Handle the error as needed
    }
  }

  static Future<List<String>> getIssuesForVehicle(String vehicleName) async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();

      final collection = db.collection('breakdown_issues');

      // Search for issues related to the provided vehicle name
      final issuesCursor = await collection
          .find(where.eq('vehicle_name', vehicleName))
          .map((e) => e['issue'] as String)
          .toList();

      await db.close();

      return issuesCursor;
    } catch (e) {
      print('Error getting issues for vehicle: $e');
      return []; // Handle the error as needed
    }
  }
}
