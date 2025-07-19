import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:dartz/dartz.dart';

class GetBookDetailsUseCase {
  final BookRepository repository;

  GetBookDetailsUseCase(this.repository);

  Future<Either<Failure, Book>> call(String id) async {
    print("Do we have the id here"+id);
    return await repository.getBookDetails(id);
  }
}