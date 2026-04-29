import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseTestPage extends StatefulWidget {
  const FirebaseTestPage({super.key});

  @override
  State<FirebaseTestPage> createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("Sensor/data");

  String sensorValue = "Loading...";

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          sensorValue = event.snapshot.value.toString();
        });
      } else {
        setState(() {
          sensorValue = "No data found";
        });
      }
    }, onError: (error) {
      setState(() {
        sensorValue = "Error: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Test")),
      body: Center(
        child: Text(
          "Sensor Data: $sensorValue",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}