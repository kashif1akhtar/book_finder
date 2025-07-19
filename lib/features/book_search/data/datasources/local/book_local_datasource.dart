import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/data/models/book_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class BookLocalDataSource {
  Future<void> saveBook(BookModel book);
  Future<void> deleteBook(BookModel book);
  Future<List<BookModel>> getSavedBooks();
  Future<bool> isBookSaved(String id);
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  final Database database;

  BookLocalDataSourceImpl(this.database);

  @override
  Future<void> saveBook(BookModel book) async {
    try {
      await database.insert('books', book.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw CacheFailure('Failed to save book: $e');
    }
  }

  @override
  Future<void> deleteBook(BookModel book) async {
    await await database.delete(
      'books',
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }



  @override
  Future<List<BookModel>> getSavedBooks() async {
    try {
      final maps = await database.query('books');
      return maps.map((map) => BookModel(
        id: map['id'] as String,
        title: map['title'] as String,
        author: map['author'] as String?,
        coverUrl: map['coverUrl'] as String?,
      )).toList();
    } catch (e) {
      throw CacheFailure('Failed to fetch saved books: $e');
    }
  }

  @override
  Future<bool> isBookSaved(String id) async {
    final result =  await database.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}