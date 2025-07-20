import 'package:book_finder/features/book_search/data/datasources/local/book_local_datasource.dart';
import 'package:book_finder/features/book_search/data/datasources/remote/book_remote_datasource.dart';
import 'package:book_finder/features/book_search/data/repositories/book_repositories_impl.dart';
import 'package:book_finder/features/book_search/domain/repositories/book_repository.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_detail_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_more_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_saved_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/getbook_usecase.dart';
import 'package:book_finder/features/book_search/domain/usecases/savebook_usecase.dart';
import 'package:book_finder/features/book_search/presentation/providers/book_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Logger
  getIt.registerSingleton<Logger>(Logger());

  // Dio
  getIt.registerSingleton<Dio>(Dio());

  // Database
  final database = await openDatabase(
    join(await getDatabasesPath(), 'books.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, author TEXT, coverUrl TEXT, description TEXT)',
      );
    },
    version: 1,
  );
  getIt.registerSingleton<Database>(database);

  // Data sources
  getIt.registerSingleton<BookRemoteDataSource>(BookRemoteDataSourceImpl(getIt<Dio>()));
  getIt.registerSingleton<BookLocalDataSource>(BookLocalDataSourceImpl(getIt<Database>()));

  // Repository
  getIt.registerSingleton<BookRepository>(
    BookRepositoryImpl(getIt<BookRemoteDataSource>(), getIt<BookLocalDataSource>()),
  );

  // Use cases
  getIt.registerSingleton<GetBooksUseCase>(GetBooksUseCase(getIt<BookRepository>()));
  getIt.registerSingleton<GetBookDetailsUseCase>(GetBookDetailsUseCase(getIt<BookRepository>()));
  getIt.registerSingleton<SaveBookUseCase>(SaveBookUseCase(getIt<BookRepository>()));
  getIt.registerSingleton<GetSavedBooksUseCase>(GetSavedBooksUseCase(getIt<BookRepository>()));
  getIt.registerSingleton<GetBooksMoreUseCase>(GetBooksMoreUseCase(getIt<BookRepository>()));

  // ViewModel
  getIt.registerFactory<BookProvider>(() => BookProvider(
    getIt<GetBooksUseCase>(),
    getIt<GetBookDetailsUseCase>(),
    getIt<SaveBookUseCase>(),
    getIt<GetSavedBooksUseCase>(),
    getIt<Logger>()
  ));
}
