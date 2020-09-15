import 'package:floor/floor.dart';
import 'package:trabalho_fiap_flutter/models/character.dart';

@dao
abstract class CharacterDao {
  @Query('SELECT * FROM Character')
  Future<List<Character>> findAllCharacteres();

  @Query('SELECT * FROM Character WHERE characterId = :id')
  Future<Character> findCharacterById(int id);

  @insert
  Future<void> insertCharacter(Character character);

  @Query('DELETE FROM Character WHERE characterId = :id')
  Future<void> deleteCharacter(int id);
}
