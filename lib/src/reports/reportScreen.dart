import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map<String, int> reportesPorBarrio = {
    "SAN FRANCISCO": 10,
    "JUAN XXIII": 15,
    "CRISTO REY": 5,
    "MARABELITO": 8,
    "LOS ALMENDROS": 12,
    "CAMINO REAL": 6,
    "LA PRIMAVERA": 3,
    "LOS LAGOS": 9,
    "EL DORADO": 7,
    "PRIMERO DE MAYO": 11,
    "ACOLSURE": 4,
    "BUENOS AIRES": 14,
    "LLANADAS": 2,
    "SANTA CLARA": 9,
    "EL CARMEN": 6,
    "SAUCES": 13,
  };

  int totalReportes = 0;

  @override
  void initState() {
    super.initState();
    totalReportes = reportesPorBarrio.values.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reportes'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context!, 'user/mapscreen', (route) => false);
              
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Cantidad de Reportes Generales'),
            trailing: Text(totalReportes.toString()),
          ),
          ListTile(
            title: Text('Cantidad de Reportes por Barrio'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reportesPorBarrio.length,
              itemBuilder: (context, index) {
                String barrio = reportesPorBarrio.keys.toList()[index];
                int cantidad = reportesPorBarrio.values.toList()[index];
                return ListTile(
                  title: Text(barrio),
                  trailing: Text(cantidad.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
