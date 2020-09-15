import 'package:floor/floor.dart';

@entity
class Character {
  @PrimaryKey(autoGenerate: true)
  int id;
  int characterId;
  String name;
  String description;
  String urlImage;

  Character({this.id, this.name, this.description, this.urlImage});

  Character.fromJson(Map<String, dynamic> json)
      : characterId = json['id'],
        name = json['name'],
        description = json['description'],
        urlImage = json['thumbnail']['path'] +
            "/landscape_amazing." +
            json['thumbnail']["extension"];

  Map<String, dynamic> toJson() => {
        'id': characterId,
        'name': name,
        'description': description,
        'thumbnail': urlImage,
      };
}
