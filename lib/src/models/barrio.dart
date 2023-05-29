import 'dart:convert';

Barrio BarrioFromJson(String str) => Barrio.fromJson(json.decode(str));
String barrioToJson(Barrio data) => json.encode(data.toJson());

class Barrio {
  int? cod_barrio;
  String? nombre;


  Barrio(
      {this.cod_barrio,
      this.nombre
      });

  factory Barrio.fromJson(Map<String, dynamic> json) => Barrio(
        cod_barrio: json["cod_barrio"],
        nombre: json["nombre"]
      );

  Map<String, dynamic> toJson() => {
        "cod_barrio": cod_barrio,
        "nombre": nombre
      };
}