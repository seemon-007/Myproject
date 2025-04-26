import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:polyline_codec/polyline_codec.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<LatLng> _latLngList = [];
  List<LatLng> _routePoints = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedLocationDetails;
  List<Marker> _markers = [];
  final MapController _mapController = MapController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  Future<void> _getRoute() async {
    if (_markers.length < 2) return;

    final startPoint = _markers[0].point;
    final endPoint = _markers[1].point;

    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${startPoint.longitude},${startPoint.latitude};${endPoint.longitude},${endPoint.latitude}?overview=full');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        String encodedPolyline = data['routes'][0]['geometry'];
        final polyline = PolylineCodec.decode(encodedPolyline);

        setState(() {
          _routePoints = polyline.map((point) {
            return LatLng(point[0].toDouble(), point[1].toDouble());
          }).toList();
        });
      } catch (e) {
        print('Error processing polyline: $e');
      }
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(data.map((place) {
          return {
            'lat': double.parse(place['lat']),
            'lon': double.parse(place['lon']),
            'name': place['display_name'],
          };
        }));
        _isSearching = false;
      });
    }
  }

  Future<void> _fetchLocationDetails(LatLng latLng) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?'
          'lat=${latLng.latitude}&'
          'lon=${latLng.longitude}&'
          'format=json&'
          'addressdetails=1');

      final response =
      await http.get(url, headers: {'User-Agent': 'YourApp/1.0'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'];

        final List<String> addressParts = [];

        if (address['road'] != null) addressParts.add(address['road']);
        if (address['suburb'] != null) addressParts.add(address['suburb']);
        if (address['city'] != null) addressParts.add(address['city']);
        if (address['state'] != null) addressParts.add(address['state']);
        if (address['postcode'] != null) addressParts.add(address['postcode']);

        setState(() {
          _selectedLocationDetails = addressParts.join(', ');
        });
      }
    } catch (e) {
      setState(() {
        _selectedLocationDetails = 'Error fetching location details';
      });
    }
  }

  void _addMarker(LatLng point, String? name) {
    setState(() {
      if (_markers.length >= 2) {
        _markers.clear();
        _routePoints = [];
      }

      _markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          rotate: true,
          child: Icon(
            Icons.location_on,
            size: 40.0,
            color: _markers.isEmpty ? Colors.red : Colors.blue,
          ),
        ),
      );

      if (_markers.length == 2) {
        _getRoute();
      }
    });
  }

  void _onSearchResultSelected(Map<String, dynamic> result) {
    final point = LatLng(result['lat'], result['lon']);
    _addMarker(point, result['name']);
    _selectedLocationDetails = result['name'];
    _searchResults = [];
    _searchController.text = '';
    _mapController.move(point, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map with Location"),
        actions: [
          if (_markers.isNotEmpty) // ตรวจสอบว่ามี Marker อยู่หรือไม่
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _markers.clear();
                  _routePoints = [];
                  _selectedLocationDetails = null;
                });
              },
            ),
          if (_markers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check), // ปุ่มตกลง
              onPressed: () {
                if (_markers.isNotEmpty) {
                  Navigator.pop(context, _markers.last.point); // ส่งค่าพิกัดกลับไป
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search for a location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchLocation(value);
                  },
                ),
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_searchResults.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          title: Text(result['name'] ?? ''),
                          subtitle: Text(
                            '${result['lat']}, ${result['lon']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          onTap: () => _onSearchResultSelected(result),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (_selectedLocationDetails != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Location: $_selectedLocationDetails',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(13.736717, 100.523186),
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  _addMarker(point, null);
                  _fetchLocationDetails(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _markers,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}