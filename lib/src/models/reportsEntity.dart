import 'dart:convert';

ReportEntity ReportEntityFromJson(String str) => ReportEntity.fromJson(json.decode(str));
String reportEntityToJson(ReportEntity data) => json.encode(data.toJson());

class ReportEntity {
  int? id;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? image;

  ReportEntity({
    this.id,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.image
  });

  factory ReportEntity.fromJson(Map<String, dynamic> json) => ReportEntity(
        id: json["id"],
        description: json["description"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "image": image,
  };
}