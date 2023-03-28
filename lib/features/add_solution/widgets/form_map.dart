import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:opale/features/add_solution/ressources/add_methods.dart';
import 'package:opale/features/add_solution/widgets/text_field_input.dart';
import 'package:opale/features/constant/layout.dart';
import 'package:opale/features/constant/ressources/geo.dart';
import 'package:opale/features/constant/ressources/snackbar.dart';
import 'package:opale/theme/pallete.dart';

class FormMap extends StatefulWidget {
  final String name;
  final String uid;
  final String description;
  final String link;
  final String type;
  final Uint8List file;
  final int color;
  final String logo;
  final String typename;
  final String profImage;
  final String username;
  final ValueChanged<bool> exit;
  final bool isMod;
  final String id;
  final String photoUrl;
  const FormMap({
    Key? key,
    required this.color,
    required this.name,
    required this.description,
    required this.link,
    required this.exit,
    required this.uid,
    required this.file,
    required this.type,
    required this.logo,
    required this.typename,
    required this.profImage,
    required this.username,
    this.isMod = false,
    this.id = '',
    this.photoUrl = '',
  }) : super(key: key);

  @override
  State<FormMap> createState() => _FormMapState();
}

class _FormMapState extends State<FormMap> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  final TextEditingController _mController = TextEditingController();
  late GoogleMapController mapController;
  LatLng _currentMapPosition = const LatLng(40.7492, -73.9675);
  bool isLoading = false;
  bool _isLoading = false;
  bool isSet = false;
  bool _isSet = false;
  String address = 'UN Geneva';
  List<GeoPoint> positions = [];
  List<double> radia = [];
  List<int> impacts = [];
  List<Marker> markers = [];
  List<Circle> circles = [];
  int impact = 1;

  @override
  void initState() {
    super.initState();
    _latController.text = _currentMapPosition.latitude.toString();
    _lngController.text = _currentMapPosition.longitude.toString();
    _mController.text = '500';
  }

  @override
  void dispose() {
    super.dispose();
    _latController.dispose();
    _lngController.dispose();
    _mController.dispose();
  }

  void addSolution() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });
    // signup user using our authmethodds
    String res = 'error';
    if (!widget.isMod) {
      res = await AddMethods().uploadSolution(
        widget.name,
        widget.description,
        widget.link,
        widget.file,
        widget.uid,
        impacts,
        positions,
        radia,
        widget.type,
        widget.color,
        widget.username,
        widget.profImage,
        widget.typename,
        widget.logo,
      );
    } else {
      res = await AddMethods().modifySolution(
        widget.name,
        widget.description,
        widget.link,
        widget.file,
        impacts,
        positions,
        radia,
        widget.username,
        widget.profImage,
        widget.photoUrl,
        widget.id,
      );
    }
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Layout(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  Future<void> _onAddMarkerButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    address = await getAddressFromLatLng(_currentMapPosition);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(_currentMapPosition.toString()),
        position: _currentMapPosition,
        infoWindow: InfoWindow(
            title: 'target location #${markers.length}', snippet: address),
        icon: BitmapDescriptor.defaultMarker,
      ));
      circles.add(Circle(
        circleId: CircleId(_currentMapPosition.toString()),
        fillColor: Color(widget.color).withOpacity(impact * 0.05),
        strokeColor: Color(widget.color),
        strokeWidth: 2,
        radius: double.parse(_mController.text),
        center: _currentMapPosition,
      ));
      _latController.text = _currentMapPosition.latitude.toString();
      _lngController.text = _currentMapPosition.longitude.toString();
      positions.add(GeoPoint(
          _currentMapPosition.latitude, _currentMapPosition.longitude));
      impacts.add(impact);
      radia.add(double.parse(_mController.text));
      _isLoading = false;
    });
  }

  Future<void> _onAddPositionButtonPressed() async {
    setState(() {
      _isLoading = true;
    });
    LatLng position = await getGeoLocation();
    setState(() {
      _latController.text = position.latitude.toString();
      _lngController.text = position.longitude.toString();
      _isLoading = false;
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude), 14));
  }

  Future<void> _onPinTextField() async {
    setState(() {
      _isLoading = true;
    });
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(double.parse(_latController.text),
            double.parse(_lngController.text)),
        14));
    setState(() {
      _isLoading = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentMapPosition,
              zoom: 8.0,
            ),
            markers: Set<Marker>.of(markers),
            circles: Set<Circle>.of(circles),
            onCameraMove: _onCameraMove),
        isSet
            ? Container()
            : Align(
                alignment: _isLoading ? Alignment.center : Alignment.topRight,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Color(widget.color),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  widget.exit(false);
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(widget.color),
                              mini: true,
                              child:
                                  const Icon(Icons.close_rounded, size: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              onPressed: () => addSolution(),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(widget.color),
                              mini: true,
                              child:
                                  const Icon(Icons.check_rounded, size: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              onPressed: _onAddPositionButtonPressed,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(widget.color),
                              mini: true,
                              child: const Icon(
                                  Icons.location_searching_rounded,
                                  size: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                if (_isSet) {
                                  setState(() {
                                    _isSet = false;
                                  });
                                } else {
                                  setState(() {
                                    _isSet = true;
                                  });
                                }
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(widget.color),
                              mini: true,
                              child: const Icon(Icons.location_on_outlined,
                                  size: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                if (isSet) {
                                  setState(() {
                                    isSet = false;
                                  });
                                } else {
                                  setState(() {
                                    isSet = true;
                                  });
                                }
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor: Color(widget.color),
                              mini: true,
                              child: const Icon(Icons.map_rounded, size: 30.0),
                            ),
                          ),
                        ],
                      ),
              ),
        isSet
            ? Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Color(widget.color),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFieldInput(
                              textEditingController: _latController,
                              isLabel: true,
                              label: 'Latitude',
                              hintText: 'Enter latitude',
                              icon: Icon(
                                Icons.swap_horizontal_circle_outlined,
                                color: Color(widget.color),
                              ),
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFieldInput(
                              textEditingController: _lngController,
                              isLabel: true,
                              label: 'Longitude',
                              hintText: 'Enter longitude',
                              icon: Icon(
                                Icons.swap_vertical_circle_outlined,
                                color: Color(widget.color),
                              ),
                              textInputType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isSet = false;
                                });
                                _onPinTextField;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(widget.color),
                              ),
                              child: const Text(
                                "Continue",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            : _isSet
                ? Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Color(widget.color),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Container(
                              color: Pallete.whiteColor.withOpacity(0.5),
                              height: 500,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rate the impact of your solution",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'OdibeeSans',
                                      color: Color(widget.color),
                                    ),
                                  ),
                                  const Text(
                                    "1 for local minor improvements and 10 for global major improvements",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Macondo',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  NumberPicker(
                                    value: impact,
                                    minValue: 1,
                                    maxValue: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        impact = value;
                                      });
                                    },
                                    axis: Axis.horizontal,
                                    selectedTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Color(widget.color),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  TextFieldInput(
                                    textEditingController: _mController,
                                    isLabel: true,
                                    label: 'Influence radius in meters',
                                    hintText: 'Enter the radius of influence',
                                    icon: Icon(
                                      Icons.circle_outlined,
                                      color: Color(widget.color),
                                    ),
                                    textInputType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _onAddMarkerButtonPressed();
                                          setState(() {
                                            _isSet = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(widget.color),
                                        ),
                                        child: const Text(
                                          "Add",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Pallete.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            markers.removeLast();
                                            circles.removeLast();
                                            impacts.removeLast();
                                            radia.removeLast();
                                            positions.removeLast();
                                            _isSet = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(widget.color),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Pallete.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isSet = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(widget.color),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Pallete.whiteColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                  )
                : Container(),
      ],
    );
  }
}
