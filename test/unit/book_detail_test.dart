import 'package:book_finder/core/error/error_handle.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_detail_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  late GetBookDetailsUseCase usecase;
  late MockBookRepository mockRepository;

  setUp() {
    mockRepository = MockBookRepository();
    usecase = GetBookDetailsUseCase(mockRepository);
  }

  final tId = 'OL55806W';
  final tBook = Book(id: 'OL55806W', title: 'Test Book', author: 'Author', coverUrl: 'url', description: 'Description');

  test('should get book details from the repository', () async {
    // Arrange
    when(mockRepository.getBookDetails(tId)).thenAnswer((_) async => Right(tBook));

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, Right(tBook));
    verify(mockRepository.getBookDetails(tId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return server failure when repository fails', () async {
    // Arrange
    when(mockRepository.getBookDetails(tId)).thenAnswer((_) async => Left(ServerFailure('Server error')));

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, Left(ServerFailure('Server error')));
    verify(mockRepository.getBookDetails(tId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return rate limit failure when repository fails with 429', () async {
    // Arrange
    when(mockRepository.getBookDetails(tId)).thenAnswer((_) async => Left(RateLimitFailure('Rate limit exceeded')));

    // Act
    final result = await usecase(tId);

    // Assert
    expect(result, Left(RateLimitFailure('Rate limit exceeded')));
    verify(mockRepository.getBookDetails(tId));
    verifyNoMoreInteractions(mockRepository);
  });
}