import 'dart:core';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_report/map_markers_death.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:street_report/src/models/report.dart';
import 'package:street_report/src/models/barrio.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:street_report/firebase_options.dart';
import 'package:postgres/postgres.dart';
import 'package:dotted_border/dotted_border.dart';

import '../api/enviroment.dart';
import '../models/response_api.dart';
import '../provider/report_provider.dart';
import '../utils/shared_pref.dart';
import 'mapScreenUsuarioController.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGF2aWQyNTExIiwiYSI6ImNsZ3JnMGs1eTFpa2kzZ211Z3FkYXdwdGUifQ.-zKTIZtvJkEYweXRBtHzBQ';
const MAPBOX_STYLE = 'mapbox/navigation-night-v1';
const MAKER_COLOR = Colors.redAccent;
const MARKER_SIZE_EXPANDED = 45.0;
const MARKER_SIZE_SHRINK = 38.0;

class MapScreenUsuario extends StatefulWidget {
  const MapScreenUsuario({
    Key? key,
  }) : super(key: key);

  @override
  State<MapScreenUsuario> createState() => _MapScreenUsuarioState();
}

class _MapScreenUsuarioState extends State<MapScreenUsuario> {
  MapScreenUsuarioController _con = new MapScreenUsuarioController();
  ReportProvider reportProvider = new ReportProvider();
  final SharedPref _sharedPref = SharedPref();
  List<Marker> _markersWarning = [];
  List<String> _addresses = [];
  List<MapMarker> mapMaker = [];
  Position? _currentPosition;
  bool isLoading = true;
  double currentZoom = 16.5;
  MapController mapController = MapController();
  final _pageController = PageController();
  int _selectedIndex = 0;
  File? imagen;
  final ImagePicker _picker = ImagePicker();
  List<Report> reports = [];
  List<File> images = [];

  late List listaBarrio;
  String _url = Enviroment.API_STREET_REPORT;
  String _apiBarrio = "/api/barrios";
  String _apiMarkerU = "/api/reports";
  String _apiMarkerE = "/api/reportsEntity";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getAllBarrio();
    getAllMarkerU();
    getAllMarkerE();
  }

  List<dynamic> dataUser = [];
  List<dynamic> dataEntity = [];
  List<Marker> _markersUser = [];
  List<Marker> _markersEntity = [];

  Future getAllMarkerU() async {
    const JsonDecoder decoder = JsonDecoder();
    Uri url = Uri.http(_url, '$_apiMarkerU/getAll');
    var response = await http.get(url);
    var jsonData = decoder.convert(response.body);

    setState(() {
      dataUser = jsonData;
      _markersUser = fetchMarkersFromDataU(dataUser);
    });

    print(jsonData);
    return "success";
  }

  Future getAllMarkerE() async {
    const JsonDecoder decoder = JsonDecoder();
    Uri url = Uri.http(_url, '$_apiMarkerE/getAll');
    var response = await http.get(url);
    var jsonData = decoder.convert(response.body);

    setState(() {
      dataEntity = jsonData;
      _markersEntity = fetchMarkersFromDataE(dataEntity);
    });

    print(jsonData);
    return "success";
  }

  List<Marker> fetchMarkersFromDataU(List<dynamic> dataUser) {
    List<Marker> markers = [];

    for (var item in dataUser) {
      double latitude = item['latitude'];
      double longitude = item['longitude'];
      String description = item['description'];
      String address = item['address'];

      Marker marker = Marker(
        width: 60.0,
        height: 60.0,
        point: LatLng(latitude, longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {
            showDialog(
              context: ctx,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Reporte'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Descripcion: ${description}'),
                      Text('Direccion: ${address}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.circle,
            color: Color.fromARGB(255, 255, 0, 0),
          ),
        ),
      );

      markers.add(marker);
    }

    return markers;
  }

  List<Marker> fetchMarkersFromDataE(List<dynamic> dataEntity) {
    List<Marker> markers = [];

    for (var item in dataEntity) {
      double latitude = item['latitude'];
      double longitude = item['longitude'];
      String description = item['description'];
      String address = item['address'];

      Marker marker = Marker(
        width: 60.0,
        height: 60.0,
        point: LatLng(latitude, longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {
            showDialog(
              context: ctx,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Reporte'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Descripcion: ${description}'),
                      Text('Direccion: ${address}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.cell_tower,
            color: Color.fromARGB(255, 255, 166, 0),
          ),
        ),
      );

      markers.add(marker);
    }

    return markers;
  }

  void selectImages() async {
    var res = await _con.pickImage();
    setState(() {
      images = res;
    });
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Marker> _buildMarkersDeath() {
    final _markerList = <Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      _markerList.add(Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                _selectedIndex = i + 1;
                setState(() {
                  _pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticInOut);
                  print('selected: ${mapItem.title}');
                });
              },
              child: _LocationMarker(
                selected: _selectedIndex == i,
              ),
            );
          }));
    }
    return _markerList;
  }

  String? selectBarrio;
  List<dynamic> dataBarrios = [];

  Future getAllBarrio() async {
    const JsonDecoder decoder = JsonDecoder();
    Uri url = Uri.http(_url, '$_apiBarrio/getAll');
    var response = await http.get(url);
    var jsonData = decoder.convert(response.body);

    setState(() {
      dataBarrios = jsonData;
    });

    print(jsonData);
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    final _markerList = _buildMarkersDeath();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Street Report'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              _con.logout(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.document_scanner,
              color: Colors.white,
            ),
            onPressed: () {
              _con.reportScreen(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 150.0,
                      child: ListView.builder(
                        itemCount: _markersWarning.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Obtiene la fecha actual
                          DateTime currentDate = DateTime.now();
                          // Formatea la fecha en el formato deseado
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(currentDate);
                          return ListTile(
                            title: Text('Reporte ${index + 1}'),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_addresses[index]),
                                Text(
                                    formattedDate), // Muestra la fecha al lado derecho
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          zoom: currentZoom,
                          onTap: (mapPoint, point) {
                            _con.latitudeController.text =
                                point.latitude.toString();
                            _con.longitudeController.text =
                                point.longitude.toString();

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Reportar mal estado'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _con.descriptionController,
                                        decoration: InputDecoration(
                                          labelText: 'Descripción del problema',
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        width: double.infinity,
                                        child: DropdownButton(
                                          value: selectBarrio,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: dataBarrios.map(
                                            (list) {
                                              return DropdownMenuItem(
                                                child: Text(list['nombre']),
                                                value: list['cod_barrio']
                                                    .toString(),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectBarrio = value as String?;
                                            });
                                            print(value);
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      TextField(
                                        controller: _con.addressController,
                                        decoration: InputDecoration(
                                          labelText: 'Describa la ubicacion',
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      images.isNotEmpty
                                          ? CarouselSlider(
                                              items: images.map(
                                                (i) {
                                                  return Builder(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Image.file(
                                                      i,
                                                      fit: BoxFit.cover,
                                                      height: 200,
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              options: CarouselOptions(
                                                viewportFraction: 1,
                                                height: 200,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: selectImages,
                                              child: DottedBorder(
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(10),
                                                dashPattern: const [10, 4],
                                                strokeCap: StrokeCap.round,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.folder_open,
                                                          size: 40,
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          'Select Image',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                      /*CircleAvatar(
                                          backgroundImage: imagen != null
                                              ? FileImage(imagen!)
                                                  as ImageProvider
                                              : _con.report?.image != null
                                                  ? AssetImage(
                                                      _con.report!.image!)
                                                  : const AssetImage(
                                                      'assets/img/select_image.jpg'),
                                          radius: 60,
                                          backgroundColor: Colors.grey[200],
                                          child: IconButton(
                                            onPressed: () {
                                              opciones(context);
                                            },
                                            icon: Icon(Icons.panorama),
                                            color: Colors.grey,
                                          )),*/
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await _upLoadImage;
                                        setState(() {
                                          _markersWarning.add(
                                            Marker(
                                              width: 60.0,
                                              height: 60.0,
                                              point: point,
                                              builder: (ctx) => GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: ctx,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Reporte'),
                                                        content: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                'Descripcion: ${_con.descriptionController.text}'),
                                                            Text(
                                                                'Direccion: ${_con.addressController.text}'),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text('Close'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.circle,
                                                  color: Color.fromARGB(
                                                      255, 255, 0, 0),
                                                ),
                                              ),
                                            ),
                                          );
                                          _addresses
                                              .add(_con.addressController.text);
                                        });
                                        _con.create();
                                        Navigator.pop(context!);
                                      },
                                      child: Text('Reportar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        nonRotatedChildren: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            additionalOptions: {
                              'accessToken': MAPBOX_ACCESS_TOKEN,
                              'id': MAPBOX_STYLE,
                            },
                          ),
                          MarkerLayer(
                            markers: _markersUser,
                          ),
                          MarkerLayer(
                            markers: _markersEntity,
                          ),
                          MarkerLayer(
                            markers: _markerList,
                          ),
                          MarkerLayer(
                            markers: _markersWarning,
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              width: 50.0,
                              height: 50.0,
                              point: LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              builder: (ctx) => Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      itemCount: mapMarkers.length,
                      itemBuilder: (context, index) {
                        final item = mapMarkers[index];
                        return _MapItemDetails(
                          mapMarker: item,
                        );
                      }),
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.small(
              heroTag: 'zoomin',
              onPressed: _zoomin,
              child: Icon(Icons.zoom_in),
              backgroundColor: Colors.blueAccent,
              hoverColor: Colors.blue.shade400,
            ),
            SizedBox(
              height: 8,
            ),
            FloatingActionButton.small(
              heroTag: 'zoom_out',
              onPressed: () {
                _zoomout();
              },
              child: const Icon(Icons.zoom_out),
              backgroundColor: Colors.blueAccent,
              hoverColor: Colors.blue.shade400,
            ),
          ],
        ),
      ),
    );
  }

  opciones(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
                child: Column(
              children: [
                InkWell(
                  onTap: _openCamera,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tomar una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.camera_alt)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _openGallery,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Seleccionar una foto',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.image_rounded)
                      ],
                    ),
                  ),
                )
              ],
            )),
          );
        });
  }

  void _upLoadImage() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final metadata = SettableMetadata(contentType: "image/jpeg");

    final storageRef = FirebaseStorage.instance.ref();

    final imagesRef = storageRef.child(
        "images/ProfilePhotos/Report${_con.report?.id}/Report${_con.report?.id}.jpg");

    final uploadTask = imagesRef.putFile(imagen!, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          break;
        case TaskState.success:
          Report _report = Report(
              image:
                  "images/ProfilePhotos/Report${_con.report?.id}/Report${_con.report?.id}.jpg",
              id: _con.report!.id);
          ResponseApi responseApi = await reportProvider.updateImage(_report);
          if (responseApi.success!) {
            _con.report =
                Report.fromJson(await _sharedPref.read('report') ?? {});
            Report report1 =
                Report.fromJson(await _sharedPref.read('report') ?? {});
            print(report1.toJson());
          }
          break;
      }
    });
  }

  void _openCamera() async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (picture != null) {
        imagen = File(picture.path);
      } else {
        print('No ha tomado la foto');
      }
    });
    Navigator.of(context).pop();
  }

  void _openGallery() async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        imagen = File(picture.path);
      } else {
        print('Seleccione una foto');
      }
    });
    Navigator.of(context).pop();
  }

  void _zoomin() {
    if (currentZoom < 18.4) {
      currentZoom = currentZoom + 0.4;
      mapController.move(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          currentZoom);
    }
  }

  void _zoomout() {
    currentZoom = currentZoom - 0.4;
    mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        currentZoom);
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({
    Key? key,
    this.selected = false,
  }) : super(key: key);

  final bool selected;
  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINK;
    return Center(
        child: AnimatedContainer(
      height: size,
      width: size,
      duration: const Duration(milliseconds: 300),
      child: Image.asset('assets/img/esqueleto.png'),
    ));
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? key,
    required this.mapMarker,
  }) : super(key: key);

  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    final _styleTittle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleDescription = TextStyle(color: Colors.grey[800], fontSize: 14);

    final accidentData = mapMarker.accidentData;

    final series = accidentData.map((data) {
      final color = data.type == 'Lecionados'
          ? charts.MaterialPalette.blue.shadeDefault
          : charts.MaterialPalette.red.shadeDefault;
      return charts.Series<AccidentData, String>(
        id: '${data.vehicleType}-${data.value}',
        domainFn: (AccidentData data, _) => data.vehicleType,
        measureFn: (AccidentData data, _) => data.value,
        colorFn: (_, __) => color,
        data: [data],
        radiusPxFn: (AccidentData data, _) => 4,
        strokeWidthPxFn: (_, __) => 2,
        labelAccessorFn: (AccidentData data, _) => '${data.value}',
      );
    }).toList();

    final chart = charts.BarChart(
      series,
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(20),
      ),
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
      behaviors: [
        charts.SeriesLegend(
            position: charts.BehaviorPosition.end,
            desiredMaxRows: 3,
            desiredMaxColumns: 2,
            entryTextStyle: charts.TextStyleSpec(color: charts.Color.black)),
        charts.SeriesLegend(
          position: charts.BehaviorPosition.end,
          desiredMaxRows: 3,
          desiredMaxColumns: 1,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(color: charts.Color.black),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        mapMarker.title,
                        style: _styleTittle,
                      ),
                      Text(
                        mapMarker.description,
                        style: _styleDescription,
                      )
                    ],
                  ))
                ])),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: chart,
                ),
              ]),
            ),
            /*MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () => null,
              color: Colors.blueAccent,
              elevation: 6,
              child: Text(
                'Cerrar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
