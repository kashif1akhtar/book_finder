import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  late GetBooksUseCase usecase;
  late MockBookRepository mockRepository;

  setUp(() {
    mockRepository = MockBookRepository();
    usecase = GetBooksUseCase(mockRepository);
  });

  final tQuery = 'test';
  final tPage = 1;
  final tBooks = [
    Book(id: '1', title: 'Test Book', author: 'Author', coverUrl: 'url'),
  ];

  test('should get books from the repository', () async {
    // Arrange
    when(mockRepository.searchBooks(tQuery, tPage)).thenAnswer((_) async => Right(tBooks));

    // Act
    final result = await usecase(tQuery, tPage);

    // Assert
    expect(result, Right(tBooks));
    verify(mockRepository.searchBooks(tQuery, tPage));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    when(mockRepository.searchBooks("Any Query", 1)).thenAnswer((_) async => Left(ServerFailure('Server error')));

    // Act
    final result = await usecase(tQuery, tPage);

    // Assert
    expect(result, Left(ServerFailure('Server error')));
    verify(mockRepository.searchBooks(tQuery, tPage));
    verifyNoMoreInteractions(mockRepository);
  });
}