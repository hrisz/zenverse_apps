import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://zenversegames-ba223a40f69e.herokuapp.com';

  Future<List<GamesModel>?> getAllGames() async {
  try {
    var response = await dio.get('$_baseUrl/games');

    if (response.statusCode == 200) {
      final gameList = (response.data['data'] as List)
          .map((game) => GamesModel.fromJson(game))
          .toList();

      return gameList;
    }
    return null;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode != 200) {
      debugPrint('Client error - the request cannot be fulfilled');
      return null;
    }
    rethrow;
  } catch (e) {
    rethrow;
  }
}

Future<GamesModel?> getGamesById(String id) async {
    try {
      var response = await dio.get('$_baseUrl/games/$id');
      if (response.statusCode == 200) {
        final data = response.data;
        return GamesModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }


}