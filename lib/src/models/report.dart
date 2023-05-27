import 'dart:convert';

Report ReportFromJson(String str) => Report.fromJson(json.decode(str));
String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  int? id;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? image;

  Report({
    this.id,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.image
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
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
