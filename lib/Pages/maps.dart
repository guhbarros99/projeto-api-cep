import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projeto_2/Services/location_service.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final LocationService _locationService = LocationService();
  LatLng? _currentPosition;

  MapController controller = MapController();

  List<Marker> _Markers = [];
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void setInitialMarker() {
    setState(() {
      _Markers.add(
        Marker(
          point: _currentPosition!, // Exemplo de novo ponto
          width: 80,
          height: 80,
          child: const Icon(Icons.push_pin, color: Colors.purple, size: 35),
        ),
      );
    });
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position!.latitude, position!.longitude);
      });
      setInitialMarker();
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps')),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: controller,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.exemplo.mapa',
                ),
                MarkerLayer(markers: _Markers),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt),
        onPressed: () {
          controller.move(LatLng(-23.5280859, -46.6917602), 15);

          print(_Markers);

          setState(() {
            _Markers.add(
              Marker(
                point: const LatLng(-23.5280859, -23.5280859), // Exemplo de novo ponto
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.push_pin,
                  color: Colors.purple,
                  size: 35,
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
