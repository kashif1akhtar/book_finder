import 'package:dio/dio.dart';

import '../../models/book_model.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> searchBooks(String query, int page);
  Future<BookModel> getBookDetails(String key);
}


class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final Dio _dio;

  BookRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BookModel>> searchBooks(String query, int page) async {
    try {
      final response = await _dio.get(
        'https://openlibrary.org/search.json',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': 20,
          'fields': 'key,title,author_name,cover_i,first_publish_year,isbn,subject',
        },
      );
      final List<dynamic> docs = response.data['docs'];
      print("Response ---- "+response.toString());
      return docs.map((json) => BookModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  @override
  Future<BookModel> getBookDetails(String key) async {
    try {
      print("dev-----------"+key);
      final response = await _dio.get('https://openlibrary.org$key.json');
      print("Dev ---- some"+BookModel.fromJson(response.data).toString());
      return BookModel.fromJson(response.data);;
    } catch (e) {
      throw Exception('Failed to get book details: $e');
    }
  }
}