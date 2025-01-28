import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://zenversegames-ba223a40f69e.herokuapp.com';

  Future<List<GamesModel>?> getAllGamesHomepage() async {
  try {
    var response = await dio.get('$_baseUrl/games');

    if (response.statusCode == 200) {
      final gameList = (response.data as List)
          .map((game) => GamesModel.fromJson(game))
          .toList();

      return gameList;
    }
    return null;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode != 200) {
      debugPrint('Client error - the request cannot be fulfilled: ${e.response!.data}');
      return null;
    }
    debugPrint('Network error: ${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('Unknown error: $e');
    rethrow;
  }
}

Future<List<GamesModel>?> getGamesByRating(double rating) async {
    try {
      var response = await dio.get('$_baseUrl/games/rating', queryParameters: {'rating': rating});

      if (response.statusCode == 200) {
        final gameList = (response.data as List)
            .map((game) => GamesModel.fromJson(game))
            .toList();

        return gameList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled: ${e.response!.data}');
        return null;
      }
      debugPrint('Network error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unknown error: $e');
      rethrow;
    }
  }

  Future<List<GamesModel>?> getGamesByName(String name) async {
  try {
    var response = await dio.get(
      '$_baseUrl/games/search',
      queryParameters: {'name': name},
    );

    if (response.statusCode == 200) {
      final gameList = (response.data as List)
          .map((game) => GamesModel.fromJson(game))
          .toList();

      return gameList;
    }
    return null;
  } on DioException catch (e) {
    if (e.response != null && e.response!.statusCode != 200) {
      debugPrint('Client error - the request cannot be fulfilled: ${e.response!.data}');
      return null;
    }
    debugPrint('Network error: ${e.message}');
    rethrow;
  } catch (e) {
    debugPrint('Unknown error: $e');
    rethrow;
  }
}

}