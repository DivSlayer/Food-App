import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_app/components/buttons/circle_icon_button.dart';
import 'package:food_app/components/buttons/square_icon_button.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/services/get_location_service.dart';
import 'package:food_app/theme/colors.dart';
import 'package:food_app/utils/dimension.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key, required this.onUserPosChange, this.defaultAddress});

  final Function(LatLng) onUserPosChange;
  final AddressModel? defaultAddress;

  @override
  State<CustomMapWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  final MapController mapController = MapController();
  final LocationService _locationService = LocationService();
  LatLng? _userPosition;
  double maxZoom = 18;
  double minZoom = 10;
  double currentZoom = 10;
  double constantChange = 0.5;

  _getUserLocation() async {
    LocationData? locationData = await _locationService.getCurrentLocation();
    if (locationData != null) {
      LatLng center = LatLng(locationData.latitude!, locationData.longitude!);
      mapController.move(center, mapController.camera.zoom + 10);
      setState(() {
        _userPosition = center;
        widget.onUserPosChange(center);
      });
      zoomIn(value: 5);
    }
  }

  void zoomIn({double? value}) {
    double change = value ?? constantChange;
    if ((currentZoom + change) >= maxZoom) {
      mapController.move(
        mapController.camera.center,
        maxZoom,
      );
      setState(() {
        currentZoom = maxZoom;
      });
    } else {
      mapController.move(
        mapController.camera.center,
        currentZoom + change,
      );
      setState(() {
        currentZoom = currentZoom + change;
      });
    }
  }

  void zoomOut({double? value}) {
    double change = value ?? constantChange;
    if ((currentZoom - change) <= minZoom) {
      mapController.move(
        mapController.camera.center,
        maxZoom,
      );
      setState(() {
        currentZoom = minZoom;
      });
    } else {
      mapController.move(
        mapController.camera.center,
        currentZoom - change,
      );
      setState(() {
        currentZoom = currentZoom - change;
      });
    }
  }

  void _updateUserPosition(LatLng newPosition) {
    setState(() {
      _userPosition = newPosition;
    });
    widget.onUserPosChange(newPosition);
  }

  @override
  void initState() {
    super.initState();
    if (widget.defaultAddress == null) {
      _getUserLocation();
    } else {
      LatLng newPos = LatLng(
        double.parse(widget.defaultAddress!.latitude),
        double.parse(widget.defaultAddress!.longitude),
      );
      setState(() {
        _userPosition = newPos;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onUserPosChange(newPos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: size.height * 0.6,
        width: size.width,
        color: lightBgColor,
        child: Stack(
          children: [
            GestureDetector(
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  zoomIn(value: details.scale * constantChange);
                });
              },
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  minZoom: minZoom,
                  initialCenter: widget.defaultAddress != null
                      ? LatLng(
                          double.parse(widget.defaultAddress!.latitude),
                          double.parse(widget.defaultAddress!.longitude),
                        )
                      : const LatLng(35.72942384382627, 51.326996791947764),
                  initialZoom: widget.defaultAddress != null ? maxZoom : minZoom,
                  maxZoom: maxZoom,
                  onPositionChanged: (camera, hasChanged) {
                    _updateUserPosition(camera.center);
                  },
                ),
                children: [
                  TileLayer(
                    userAgentPackageName: 'com.maxim.app',
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => {},
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userPosition ?? const LatLng(35.72942384382627, 51.326996791947764),
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: yellowColor,
                          size: dimmension(50, context),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(
                  left: dimmension(20, context),
                  bottom: dimmension(70, context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SquareIconButton(
                      icon: Icons.my_location,
                      onTap: () {
                        _getUserLocation();
                      },
                      bgColor: lightTextColor,
                    ),
                    SizedBox(height: dimmension(15, context)),
                    SquareIconButton(
                      icon: Icons.add_rounded,
                      onTap: () {
                        zoomIn();
                      },
                      bgColor: lightTextColor,
                    ),
                    SizedBox(height: dimmension(15, context)),
                    SquareIconButton(
                      icon: CupertinoIcons.minus,
                      onTap: () {
                        zoomOut();
                      },
                      bgColor: lightTextColor,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: dimmension(15, context),
                  vertical: dimmension(45, context),
                ),
                child: CircleIconButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.chevron_left_rounded,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
