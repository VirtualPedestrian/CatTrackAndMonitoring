import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class MonitorValuePage extends StatefulWidget {
  @override
  _MonitorValuePageState createState() => _MonitorValuePageState();
}

class _MonitorValuePageState extends State<MonitorValuePage> {
  // Reference to your specific node in RTDB
  final DatabaseReference _myRTDB = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://aimansiot-fd460-default-rtdb.asia-southeast1.firebasedatabase.app//"
  ).ref();
  StreamSubscription<DatabaseEvent>? _subscription;
  bool _isDialogShowing = false; // Prevents multiple pop-ups at once

  @override
  void initState() {
    super.initState();
    _activateListener();
  }

  void _activateListener() {
    _subscription = _myRTDB.child("Sensor/BodyTemp").onValue.listen((event) {
      // 1. Extract the value (assuming it's an int or double)
      final Object? data = event.snapshot.value;
      if (data == null) return;

      final num value = data as num;
      const num threshold = 39.2; // Your "too high" limit
      const num bthreshold = 37.2;

      // 2. Check the condition
      if ( ((value > threshold) || (value < bthreshold)) && !_isDialogShowing) {
        _showWarningDialog(value);
      }
    });
  }

  void _showWarningDialog(num value) {
    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false, // Force user to acknowledge
      builder: (context) => AlertDialog(
        title: Text("Alert: Abnormal Value!"),
        content: Text("The current value is $value, which exceeds the limit."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _isDialogShowing = false;
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Important: Stop listening when page is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Monitor")),
      body: Center(child: Text("Monitoring Firebase value...")),
    );
  }
}