import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:study_flutter_location/app/screens/widgets/default_table.dart';
import 'package:study_flutter_location/app/shared/utils/location_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final locationUtils = LocationUtils();
  LocationData? locationData;
  List<double> distancesToCitiesInOrder = [];

  Future<void> _updateLocation() async {
    final data = await locationUtils.getLocation(context);
    setState(() => locationData = data);
  }

  Future<void> _calculateDistanceToCities() async {
    final distances = await locationUtils.getDistanceToCities(context);
    setState(() => distancesToCitiesInOrder = distances);
    print(distancesToCitiesInOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your current location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (locationData != null)
                DefaultTable(
                  rows: [
                    [
                      const Text('Latitude:'),
                      Text('${locationData!.latitude}'),
                    ],
                    [
                      const Text('Longitude:'),
                      Text('${locationData!.longitude}'),
                    ],
                    [
                      const Text('Altitude:'),
                      Text('${locationData!.altitude}'),
                    ],
                  ],
                )
              else
                const Text('No location data to show.'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Get current location'),
                onPressed: _updateLocation,
              ),
              const SizedBox(height: 64.0),
              const Text(
                'Your distance to cities:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (distancesToCitiesInOrder.isNotEmpty)
                DefaultTable(
                  rows: [
                    [
                      const Text('São Paulo:'),
                      Text(
                          '${distancesToCitiesInOrder[0].toStringAsFixed(2)} km'),
                    ],
                    [
                      const Text('New York:'),
                      Text(
                          '${distancesToCitiesInOrder[1].toStringAsFixed(2)} km'),
                    ],
                    [
                      const Text('Tokyo:'),
                      Text(
                          '${distancesToCitiesInOrder[2].toStringAsFixed(2)} km'),
                    ],
                    [
                      const Text('Paris:'),
                      Text(
                          '${distancesToCitiesInOrder[3].toStringAsFixed(2)} km'),
                    ]
                  ],
                )
              else
                const SizedBox(
                  height: 20.0,
                  child: Text('No data to be shown.'),
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Distance to cities'),
                onPressed: _calculateDistanceToCities,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
