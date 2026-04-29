import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ToggleButtonPage extends StatefulWidget {
  @override
  _ToggleButtonPageState createState() => _ToggleButtonPageState();
}

class _ToggleButtonPageState extends State<ToggleButtonPage> {

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("device/toggle");

  bool toggleValue = false;

  @override
  void initState() {
    super.initState();

    // Listen to realtime database changes
    dbRef.onValue.listen((event) {
      final value = event.snapshot.value;

      if (value != null) {
        setState(() {
          toggleValue = value as bool;
        });
      }
    });
  }

  void toggle() {
    bool newValue = !toggleValue;

    dbRef.set(newValue); // update Firebase

    setState(() {
      toggleValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Toggle Button")),
      body: Center(
        child: ElevatedButton(
          onPressed: toggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: toggleValue ? Colors.green : Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          child: Text(
            toggleValue ? "ON" : "OFF",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
