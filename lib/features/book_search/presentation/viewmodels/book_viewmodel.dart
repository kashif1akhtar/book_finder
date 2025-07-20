import 'package:book_finder/core/di/injections.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_detail_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_saved_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/savebook_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class BookViewModel extends StateNotifier<AsyncValue<List<Book>>> {
  final GetBooksUseCase getBooksUseCase;
  final GetBookDetailsUseCase getBookDetailsUseCase;
  final SaveBookUseCase saveBookUseCase;
  final GetSavedBooksUseCase isSaved;
  final Logger logger;
  int currentPage = 1;
  String currentQuery = '';
  bool isLoadingMore = false;

  BookViewModel(
      this.getBooksUseCase,
      this.getBookDetailsUseCase,
      this.saveBookUseCase,
      this.isSaved,
      this.logger,
      ) : super(const AsyncValue.data([]));

  Future<void> searchBooks(String query, {bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      state = const AsyncValue.data([]);
    }
    currentQuery = query;
    state = const AsyncValue.loading();
    try {
      final result = await getBooksUseCase(query, currentPage);
      result.fold(
            (failure) {
          logger.e('Error fetching books: ${failure.message}');
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
            (books) {
          state = AsyncValue.data([...state.value ?? [], ...books]);
          currentPage++;
        },
      );
    } catch (e) {
      logger.e('Unexpected error: $e');
      state = AsyncValue.error('Unexpected error occurred', StackTrace.current);
    }
  }

  Future<Book?> getBookDetails(String id) async {
    try {
      final result = await getBookDetailsUseCase(id);
      return result.fold(
            (failure) {
          logger.e('Error fetching book details: ${failure.message}');
          return null;
        },
            (book) => book,
      );
    } catch (e) {
      logger.e('Unexpected error fetching book details: $e');
      return null;
    }
  }

  Future<void> saveBook(Book book) async {
    try {
      final result = await saveBookUseCase(book);
      result.fold(
            (failure) => logger.e('Error saving book: ${failure.message}'),
            (_) => logger.i('Book saved successfully'),
      );
    } catch (e) {
      logger.e('Unexpected error saving book: $e');
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      final result = await saveBookUseCase(book);
      result.fold(
            (failure) => logger.e('Error saving book: ${failure.message}'),
            (_) => logger.i('Book saved successfully'),
      );
    } catch (e) {
      logger.e('Unexpected error saving book: $e');
    }
  }

  Future<void> loadMore(String query) async {
    if (isLoadingMore || currentQuery.isEmpty) return;
    isLoadingMore = true;
    final nexPage = currentPage +1;
    try {
      final result = await getBooksUseCase(query, nexPage);
      result.fold(
            (failure) {
          logger.e('Error fetching books: ${failure.message}');
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
            (books) {
          state = AsyncValue.data([...state.value ?? [], ...books]);
          currentPage++;
        },
      );
    } catch (e) {
      logger.e('Unexpected error: $e');
      state = AsyncValue.error('Unexpected error occurred', StackTrace.current);
    }
    finally {
      isLoadingMore = false;
    }
  }

  Future<bool> isBookSaved(Book book) async {
    try {
      final result = await isSaved(book);
      return result.fold(
            (failure) {
          logger.e('Error fetching book details: ${failure.message}');
          return false;
        },
            (book) => book,
      );
    } catch (e) {
      logger.e('Unexpected error fetching book details: $e');
      return false;
    }
  }
}

final bookViewModelProvider = StateNotifierProvider<BookViewModel, AsyncValue<List<Book>>>((ref) {
  return getIt<BookViewModel>();
});