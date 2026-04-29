import 'package:flutter/material.dart';

class AcademicIntegrity extends StatefulWidget {
  const AcademicIntegrity({super.key});

  @override
  State<AcademicIntegrity> createState() => _AcademicIntegrityState();
}

class _AcademicIntegrityState extends State<AcademicIntegrity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff379552),
        title: Text(
          "Academic Integrity",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("References", style: TextStyle(fontSize: 18),),
            SizedBox(height: 15,),
            Text("Cat normal temperature reference"),
            Text("https://vcahospitals.com/know-your-pet/taking-your-pets-temperature#:~:text=Normal%20body%20temperature%20for%20dogs,take%20them%20to%20your%20veterinarian", style: TextStyle(color: Colors.blue),),
            SizedBox(height: 8,),
            Text("Flutter navigation side bar reference"),
            Text("https://oflutter.com/create-a-sidebar-menu-in-flutter/", style: TextStyle(color: Colors.blue),),
            SizedBox(height: 8,),
            Text("Flutter OpenStreetMap plugin"),
            Text("https://pub.dev/packages/flutter_osm_plugin", style: TextStyle(color: Colors.blue),),
            SizedBox(height: 8,),
            Text("Pallas cat image source"),
            Image.network("https://en.wikipedia.org/wiki/File:Manoel.jpg"),
            Text("https://en.wikipedia.org/wiki/File:Manoel.jpg", style: TextStyle(color: Colors.blue),),
          ],
        ),
      )
    );
  }
}
