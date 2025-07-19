import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetBooksMoreUseCase {
  final BookRepository repository;

  GetBooksMoreUseCase(this.repository);

  Future<Either<Failure, List<Book>>> call(String query, int page) async {
    return await repository.searchBooks(query, page);
  }
}