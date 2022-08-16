/*
 * @Author: yang yu
 * @Date: 2022-08-01 17:14:17
 * @LastEditors: yang yu
 * @LastEditTime: 2022-08-01 17:29:34
 * @Description: file content
 */
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static proj4.Projection epsg4490Projection = proj4.Projection.add('EPSG:4490',
      'GEOGCS["China Geodetic Coordinate System 2000",DATUM["China_2000",SPHEROID["CGCS2000",6378137,298.257222101,AUTHORITY["EPSG","1024"]],AUTHORITY["EPSG","1043"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.0174532925199433,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4490"]]');
  static Bounds<double> bounds = Bounds<double>(
      const CustomPoint(-180.0, -90.0), const CustomPoint(180.0, 90.0));
  static const resolutions = <double>[
    1.40625,
    0.703125,
    0.3515625,
    0.17578125,
    0.087890625,
    0.0439453125,
    0.02197265625,
    0.010986328125,
    0.0054931640625,
    0.00274658203125,
    0.001373291015625,
    0.0006866455078125,
    0.00034332275390625,
    0.000171661376953125,
    0.0000858306884765625,
    0.00004291534423828125,
    0.000021457672119140625,
    0.000010728836059570312,
    0.000005364418029785156
  ];

  static Proj4Crs epsg4490 = Proj4Crs.fromFactory(
    code: "EPSG:4490",
    proj4Projection: epsg4490Projection,
    bounds: bounds,
    origins: [const CustomPoint(-180.0, 90.0)],
    resolutions: resolutions,
    scales: null,
    transformation: null,
  );

  int _currentMapIndex = 0;
  MapController _mapController = MapController();

  final crs3857Option = MapOptions(
      crs: const Epsg3857(),
      center: LatLng(23.388149672864074, 116.7156679026907),
      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      zoom: 14,
      minZoom: 0,
      maxZoom: 22);
  final crs4490Option = MapOptions(
      crs: epsg4490,
      center: LatLng(23.388149672864074, 116.7156679026907),
      interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      zoom: 14,
      minZoom: 0,
      maxZoom: 22);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: FlutterMap(
          mapController: _mapController,
          options: _currentMapIndex == 0 ? crs4490Option : crs3857Option,
          children: [
            if (_currentMapIndex == 0)
              TileLayer(
                maxNativeZoom: 18.0,
                maxZoom: 24,
                urlTemplate:
                    'http://t{s}.tianditu.gov.cn/img_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=c&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=8e2a7d4d3f6b01b95f9e4b618b9ddaad',
                tileProvider: NetworkTileProvider(),
                subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
              ),
            if (_currentMapIndex == 1)
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
            PolylineLayer(polylines: [
              Polyline(strokeWidth: 4.0, color: Colors.red, points: [
                LatLng(23.3884495, 116.7191143),
                LatLng(23.3806962, 116.7124767),
                LatLng(23.3799523, 116.7246074),
                LatLng(23.3716553, 116.7208881),
              ])
            ]),
            Positioned(
              bottom: 20,
              left: 20,
              child: TextButton(
                onPressed: () {
                  _currentMapIndex = _currentMapIndex == 0 ? 1 : 0;
                  setState(() {});
                },
                child: const Text("切换"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
