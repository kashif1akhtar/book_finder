import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/data/datasources/local/book_local_datasource.dart';
import 'package:book_finder/features/book_search/data/datasources/remote/book_remote_datasource.dart';
import 'package:book_finder/features/book_search/data/models/book_model.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource _remoteDataSource;
  final BookLocalDataSource _bookLocalDataSource;


  BookRepositoryImpl(this._remoteDataSource, this._bookLocalDataSource);

  @override
  Future<Either<Failure, List<Book>>> searchBooks(String query, int page) async {
    try {
      final bookModels = await _remoteDataSource.searchBooks(query, page);
      final books = bookModels
          .map((model) => Book(id: model.id, title: model.title, author: model.author, coverUrl: model.coverUrl))
          .toList();
      return Right(books);
    } catch (e) {
      return Left(e is RateLimitFailure ? e :ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Book>> getBookDetails(String id) async {
    try {
      final details = await _remoteDataSource.getBookDetails('$id');
      final book = Book(
        id: details.id,
        title: details.title,
        author: details.author ?? 'Unknown Author',
        coverUrl: details.coverUrl ?? '',
        description: details.description,
      );
      return Right(book);
    } catch (e) {
      return Left(e is RateLimitFailure ? e :ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveBook(Book book) async {
    try {
      final bookModel = BookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        coverUrl: book.coverUrl,
        description: book.description,
      );
      await _bookLocalDataSource.saveBook(bookModel);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(Book book) async {
    try {
      final bookModel = BookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        coverUrl: book.coverUrl,
        description: book.description,
      );
      await _bookLocalDataSource.deleteBook(bookModel);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookSaved(Book book) async {
    final isSaved = await _bookLocalDataSource.isBookSaved(book.id);
    return Right(isSaved);
  }

}