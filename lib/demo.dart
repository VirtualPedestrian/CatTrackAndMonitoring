import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class ResponsiveContainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the full screen size
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Percentage'),
      ),
      body: Center(
        child: Container(
          // Set width to 80% of the screen width
          width: screenWidth * 0.8,
          // Set height to 50% of the screen height
          height: screenHeight * 0.5,
          color: Colors.blue,
          child: Center(
            child: OSMFlutter(
              controller: MapController(
                initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
                areaLimit: const BoundingBox(
                  east: 10.4922941,
                  north: 47.8084648,
                  south: 45.817995,
                  west: 5.9559113,
                ),
              ),
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: true,
                  unFollowUser: false,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.location_history_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: Colors.yellowAccent,
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
