import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floor/floor.dart';

@entity
class Character {
  @PrimaryKey(autoGenerate: true)
  int id;
  int characterId;
  String name;
  String description;
  String urlImage;

  DocumentReference reference;

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

  Character.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map['characterId'],
        name = map['name'],
        description = map['description'],
        urlImage = map['urlImage'];

  Character.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
