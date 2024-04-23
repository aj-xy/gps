import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  
   Future<void> launch(double? lat, double? lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (!await launchUrl(
      Uri.parse(url)
   
    )) {
      throw Exception('Could not launch $url');
    }
  }
  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();

    if (!servicePermission) {
      print("Service Disabled");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
   
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text("Get Your Location "),
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "The Coordinates are",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Latitude = ${_currentLocation?.latitude} ; Longitude = ${_currentLocation?.longitude}"),
              ElevatedButton(
                  onPressed: () async {
                    Position location = await _getCurrentLocation();

                    setState(() {
                      _currentLocation =location;
                    });
                    print(_currentLocation!.longitude.toString());
                  },
                  child: Text("Get Location")),
                  ElevatedButton(onPressed: (){
                    launch(_currentLocation?.latitude,_currentLocation?.longitude);

                  }, child: Text("open map"))
            ],
          ),
        ),
      )),
    );
  }
}
