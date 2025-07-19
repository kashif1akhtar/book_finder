
import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<Failure, List<Book>>> searchBooks(String query, int page);
  Future<Either<Failure, Book>> getBookDetails(String id);
  Future<Either<Failure, void>> saveBook(Book book);
  Future<Either<Failure, void>> deleteBook(Book book);
  Future<Either<Failure, bool>> isBookSaved(Book book);
}