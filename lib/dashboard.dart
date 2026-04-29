import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'navbar.dart';
import 'package:cattrackandmonitoring/datacard.dart';
import 'package:firebase_database/firebase_database.dart';

class dashboardPage extends StatefulWidget {
  const dashboardPage({super.key});

  @override
  State<dashboardPage> createState() => _dashboardPageState();
}

class _dashboardPageState extends State<dashboardPage> {

  final DatabaseReference _myRTDB = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://aimansiot-fd460-default-rtdb.asia-southeast1.firebasedatabase.app//"
  ).ref();

  StreamSubscription<DatabaseEvent>? _subscription;
  bool _isDialogShowing = false; // Prevents multiple pop-ups at once


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
        title: Text("Alert: Abnormal Temperature!"),
        content: Text("The current temperature is $value, which exceeds the limit."),
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

  String BPM = "0";
  String Oxygen ="0";
  String BodyTemp ="0";
  String ActivityLevel ="NaN";
  String GPSLat ="0";
  String GPSLng ="0";

  late MapController mapController;

  GeoPoint? currentPoint;

  bool isUpdating = false;

  bool value = false;

  bool toggleValue = false;
  bool ledValue = false;

  void _readSensor(){
    //GPS LATITUDE
    _myRTDB.child("Sensor/GPSLat").onValue.listen(
            (event){
          final Object? GPSLatData = event.snapshot.value;
          setState(() {
            GPSLat = GPSLatData.toString();
          });
        }
    );
    //GPS LONGITUDE
    _myRTDB.child("Sensor/GPSLng").onValue.listen(
            (event){
          final Object? GPSLngData = event.snapshot.value;
          setState(() {
            GPSLng = GPSLngData.toString();
          });
        }
    );
    //BPM
    _myRTDB.child("Sensor/BPM").onValue.listen(
            (event){
          final Object? BPMData = event.snapshot.value;
          setState(() {
            BPM = BPMData.toString();
          });
        }
    );
    //Body Temp
    _myRTDB.child("Sensor/BodyTemp").onValue.listen(
            (event){
          final Object? BodyTempData = event.snapshot.value;
          setState(() {
            BodyTemp = BodyTempData.toString();
          });
        }
    );
    //GPS LATITUDE
    _myRTDB.child("Sensor/ActivityLevel").onValue.listen(
            (event){
          final Object? ActivityLevelData = event.snapshot.value;
          setState(() {
            ActivityLevel = ActivityLevelData.toString();
          });
        }
    );
  }

  void toggle() {
    bool newValue = !toggleValue;

    _myRTDB.child("Actuator/Buzzer").set(newValue); // update Firebase

    setState(() {
      toggleValue = newValue;
    });
  }
  void led() {
    bool newValue = !ledValue;

    _myRTDB.child("Actuator/LED").set(newValue); // update Firebase

    setState(() {
      ledValue = newValue;
    });
  }

  void startUpdatingMarker(){
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      // 1. Check if we are already in the middle of an update
      if (isUpdating) return;

      isUpdating = true; // Lock

      try {
        double lat = double.parse(GPSLat);
        double lng = double.parse(GPSLng);
        GeoPoint newPoint = GeoPoint(latitude: lat, longitude: lng);

        // 2. Only move if the coordinates actually changed
        if (currentPoint?.latitude != newPoint.latitude ||
            currentPoint?.longitude != newPoint.longitude) {

          if (currentPoint == null) {
            await mapController.addMarker(newPoint,
                markerIcon: const MarkerIcon(icon: Icon(Icons.location_on, color: Colors.red, size: 40)));
          } else {
            // Use this specific method for smoother transitions
            await mapController.changeLocationMarker(
              oldLocation: currentPoint!,
              newLocation: newPoint,
            );
          }

          // 3. Use goToLocation for a smooth animated glide
          await mapController.goToLocation(newPoint);

          currentPoint = newPoint;
        }
      } catch (e) {
        print("Update failed: $e");
      } finally {
        isUpdating = false; // Unlock
      }
    });
  }

  @override void initState() {
    super.initState();
    _activateListener();
    _readSensor();
    mapController = MapController(
      initPosition: GeoPoint(
        latitude: 47.4358055,
        longitude: 8.4737324,
      ),
    );

    _myRTDB.child("Actuator/Buzzer").onValue.listen((event) {
      final value = event.snapshot.value;

      if (value != null) {
        setState(() {
          toggleValue = value as bool;
        });
      }
    });

    startUpdatingMarker();
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          "CatTrack",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.left,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: screenWidth * 1,
                  height: screenHeight * 0.4,

                  child: Center(
                    child: OSMFlutter(
                      controller: mapController,
                      osmOption: OSMOption(
                        zoomOption: const ZoomOption(
                          initZoom: 8,
                          minZoomLevel: 3,
                          maxZoomLevel: 19,
                          stepZoom: 1.0,
                        ),
                        roadConfiguration: const RoadOption(
                          roadColor: Colors.yellowAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                DataCard(title: "Heart BPM", value: "$BPM"),
                SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Collar Ringer",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: toggleValue ? Colors.deepOrangeAccent : Colors.orangeAccent,
                        ),
                        onPressed: toggle,
                        child: Icon(Icons.ring_volume),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                DataCard(title: "Cat Activity Level", value: "$ActivityLevel"),
                SizedBox(width: 16),
                DataCard(title: "Body Temp", value: "$BodyTemp°C"),
              ],
            ),
            SizedBox(height: 16,),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Collar Light",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ledValue ? Colors.deepOrangeAccent : Colors.orangeAccent,
                    ),
                    onPressed: led,
                    child: Icon(Icons.light_mode),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}