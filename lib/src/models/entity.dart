import 'dart:convert';

Entity EntityFromJson(String str) => Entity.fromJson(json.decode(str));

String entityToJson(Entity data) => json.encode(data.toJson());

class Entity {
  String? id;
  String? email;
  String? password;
  String? name;
  String? sessionToken;

  Entity(
      {this.id,
      this.email,
      this.password,
      this.name,
      this.sessionToken
      });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      name: json["name"],
      sessionToken: json["session_token"]
    );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "session_token": sessionToken
      };
}