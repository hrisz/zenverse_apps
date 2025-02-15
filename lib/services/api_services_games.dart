import 'package:zenverse_mobile_apps/model/games_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:zenverse_mobile_apps/model/publish_model.dart';


class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'https://zenversegames-ba223a40f69e.herokuapp.com';

  Future<List<GamesModel>> getAllGamesHomepage({int page = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        '$_baseUrl/games/apps',
        queryParameters: {
          'skip': page * limit,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final gameList = (response.data as List)
            .map((game) => GamesModel.fromJson(game))
            .where((game) => game.rating > 1)
            .toList();
        return gameList;
      } else {
        debugPrint('Server error: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      debugPrint('Client error: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('Unknown error: $e');
      return [];
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
            .where((game) => game.rating > 1)
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

  Future<bool> insertGame(GamesModelPost game) async {
  try {
    final String url = '$_baseUrl/insert-game';
    final response = await dio.post(
      url,
      data: game.toJson(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint("Gagal insert game. Status Code: ${response.statusCode}, Response: ${response.data}");
      return false;
    }
  } on DioException catch (e) {
    debugPrint("DioException: ${e.message}, Data: ${e.response?.data}");
    return false;
  } catch (e) {
    debugPrint("Unexpected error: $e");
    return false;
  }
}

Future<String?> uploadImage(File imageFile) async {
  try {
    String fileName = basename(imageFile.path);
    String? mimeType = lookupMimeType(imageFile.path);
    debugPrint("MIME Type: $mimeType");

    if (mimeType == null) {
      debugPrint('Gagal mendapatkan MIME type');
      return null;
    }

    FormData formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    Response response = await dio.post(
      "$_baseUrl/upload/img",
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    debugPrint("Response: ${response.data}");

    if (response.statusCode == 200) {
      String uploadedFileName = response.data["response"];
      String fileUrl = "https://raw.githubusercontent.com/Zenith-Infinity/img-repository/main/$uploadedFileName";
      debugPrint("Upload berhasil! URL: $fileUrl");
      return fileUrl;
    } else {
      debugPrint("Gagal upload: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    debugPrint("Error upload: $e");
    return null;
  }
}


}