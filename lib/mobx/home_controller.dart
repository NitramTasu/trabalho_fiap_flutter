import 'package:dio/dio.dart';
import 'package:trabalho_fiap_flutter/models/character.dart';
import 'package:trabalho_fiap_flutter/repositories/home_repository.dart';
import 'package:mobx/mobx.dart';

part 'home_controller.g.dart';

//chave da api 8536ee7e2c02b177dd1328209053f05f
class HomeController = _HomeBase with _$HomeController;

abstract class _HomeBase with Store {
  HomeRepository homeRepository = new HomeRepository(Dio());
  @observable
  ObservableList<Character> characters = ObservableList.of([]);

  Future<List<Character>> getCharacterList() {
    return homeRepository.getCharacterSimpleList();
  }
}
