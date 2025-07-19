import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetSavedBooksUseCase {
  final BookRepository repository;

  GetSavedBooksUseCase(this.repository);

  Future<Either<Failure, bool>> call(Book book) async {
    return await repository.isBookSaved(book);
  }
}