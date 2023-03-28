import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opale/features/constant/ressources/geo.dart';
import 'package:opale/features/feed/widgets/solution_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapDisplay extends StatefulWidget {
  final List snap;
  const MapDisplay({Key? key, required this.snap}) : super(key: key);

  @override
  State<MapDisplay> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  late List<Marker> _markers;
  late List<Circle> _circles;
  late GoogleMapController mapController;
  late LatLng _currentMapPosition;
  int count = 0;
  bool _isLoading = false;
  List colors = [];

  @override
  void initState() {
    super.initState();
    _markers = setMarker();
    _circles = setCircle();
  }

  void _nextButton() {
    if (count + 1 == widget.snap.length) {
      setState(() {
        count = 0;
      });
    } else {
      setState(() {
        count = count + 1;
      });
    }
    setState(() {
      _currentMapPosition = LatLng(widget.snap[count]['center'].latitude,
          widget.snap[count]['center'].longitude);
    });
    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentMapPosition, 10));
  }

  void _previousButton() {
    if (count == 0) {
      setState(() {
        count = widget.snap.length - 1;
      });
    } else {
      setState(() {
        count = count - 1;
      });
    }
    setState(() {
      _currentMapPosition = LatLng(widget.snap[count]['center'].latitude,
          widget.snap[count]['center'].longitude);
    });
    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(_currentMapPosition, 10));
  }

  List<Marker> setMarker() {
    List<Marker> markers = [];
    for (var element in widget.snap) {
      for (int i = 0; i < element['center'].length; i++) {
        Marker mark = Marker(
            markerId: MarkerId(element["id"]),
            position: LatLng(
                element['center'][i].latitude, element['center'][i].longitude),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              setState(() {
                _currentMapPosition = LatLng(element['center'][i].latitude,
                    element['center'][i].longitude);
              });
              mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentMapPosition, 10));
            });
        markers.add(mark);
      }
    }
    return markers;
  }

  List<Circle> setCircle() {
    List<Circle> circles = [];
    for (var element in widget.snap) {
      for (int i = 0; i < element['center'].length; i++) {
        Circle cirk = Circle(
          fillColor:
              Color(element['color']).withOpacity(element['impact'][i] * 0.05),
          center: LatLng(
              element['center'][i].latitude, element['center'][i].longitude),
          radius: element['radius'][i],
          strokeWidth: 2,
          strokeColor: Color(element['color']),
          onTap: () {
            setState(() {
              _currentMapPosition = LatLng(element['center'][i].latitude,
                  element['center'][i].longitude);
            });
            mapController.animateCamera(
                CameraUpdate.newLatLngZoom(_currentMapPosition, 10));
          },
          circleId: CircleId(element["id"]),
        );
        circles.add(cirk);
      }
    }
    return circles;
  }

  Future<void> _onAddPositionButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    LatLng position = await getGeoLocation();
    setState(() {
      _isLoading = false;
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 14));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: Column(
        children: [
          const Center(child: Icon(Icons.keyboard_arrow_up_rounded)),
          const Divider(
            height: 2,
          ),
          SizedBox(
            height: 450,
            child: SingleChildScrollView(
                child: SolutionCard(snap: widget.snap[count].data())),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.snap[0]['center'][0].latitude,
                    widget.snap[0]['center'][0].longitude),
                zoom: 10.0,
              ),
              markers: Set<Marker>.of(_markers),
              circles: Set<Circle>.of(_circles),
              onCameraMove: _onCameraMove),
          _isLoading
              ? LinearProgressIndicator(
                  color: Color(widget.snap[count]['color']),
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: _previousButton,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Color(widget.snap[count]['color']),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FloatingActionButton(
                          onPressed: _onAddPositionButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Color(widget.snap[count]['color']),
                          mini: true,
                          child: const Icon(Icons.location_searching_rounded,
                              size: 30.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: _nextButton,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Color(widget.snap[count]['color']),
                          child: const Icon(Icons.arrow_forward_ios_rounded,
                              size: 30.0),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    );
  }
}
