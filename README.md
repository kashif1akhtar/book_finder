# Book Finder App

A Flutter application that allows users to search for books using the Open Library API, view book details, and save books locally using SQLite.

## Features

### Main Features
- **Search Books**: Search for books by title using the Open Library API
- **Book Details**: View detailed information about books with animated cover
- **Save Books**: Save books locally using SQLite database
- **Pull to Refresh**: Refresh search results with pull-to-refresh gesture
- **Pagination**: Load more results as user scrolls
- **Shimmer Loading**: Beautiful loading animations while fetching data

### Technical Implementation
- **Clean Architecture**: Separation of concerns with Data, Domain, and Presentation layers
- **State Management**: Riverpod for reactive state management
- **Database**: SQLite for local storage
- **Network**: Dio for HTTP requests
- **Animations**: Custom book cover rotation animation
- **Error Handling**: Comprehensive error handling for network and database operations
- **Unit Testing**: Tests for repository and provider logic

## Architecture

The app follows Clean Architecture principles:

```
lib/
├── core/
│   └── database/
│       └── database_helper.dart
├── data/
│   ├── datasources/
│   │   └── book_remote_datasource.dart
│   ├── models/
│   │   ├── book_response.dart
│   │   └── book_response.g.dart
│   └── repositories/
│       └── book_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── book.dart
│   └── repositories/
│       └── book_repository.dart
├── presentation/
│   ├── providers/
│   │   └── book_provider.dart
│   ├── screens/
│   │   ├── search_screen.dart
│   │   └── book_details_screen.dart
│   └── widgets/
│       └── book_card.dart
└── main.dart
```

## API Integration

The app integrates with the Open Library API:
- **Search Endpoint**: `https://openlibrary.org/search.json`
- **Book Details**: `https://openlibrary.org/works/{id}.json`
- **Cover Images**: `https://covers.openlibrary.org/b/id/{cover_id}-M.jpg`

## State Management

Uses Riverpod for state management with the following providers:
- `searchProvider`: Manages search state and pagination
- `bookDetailsProvider`: Fetches detailed book information
- `savedBooksProvider`: Manages locally saved books

## Database Schema

SQLite table structure:
```sql
CREATE TABLE books (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  coverUrl TEXT,
  description TEXT,
  publishYear INTEGER,
  isbn TEXT,
  createdAt TEXT NOT NULL
)
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code files:
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Running Tests

Run unit tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## Dependencies

### Main Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `sqflite`: SQLite database
- `shimmer`: Loading animations
- `cached_network_image`: Image caching
- `equatable`: Value equality
- `json_annotation`: JSON serialization

### Dev Dependencies
- `build_runner`: Code generation
- `freezed`: Data classes
- `json_serializable`: JSON serialization
- `mockito`: Mocking for tests
- `flutter_test`: Testing framework

## Features Implemented

✅ **Search Screen**
- Search bar with real-time search
- Book results with title, author, and thumbnail
- Pull-to-refresh functionality
- Shimmer loading animation
- Pagination with infinite scroll

✅ **Details Screen**
- Animated book cover (rotation)
- Book details display
- Save/unsave book functionality
- Error handling for network requests

✅ **Technical Requirements**
- REST API integration with Open Library
- Pagination support
- Riverpod state management
- Clean architecture implementation
- SQLite local storage
- Comprehensive error handling
- Unit tests for repository and provider logic

## Testing

The app includes comprehensive unit tests covering:
- Repository layer testing with mocked dependencies
- Provider state management testing
- Error handling scenarios
- Edge cases and data validation

## Future Enhancements

Potential improvements:
- Add search history
- Implement book categories/genres
- Add book rating system
- Implement offline mode
- Add book recommendations
- Social features (sharing, reviews)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License.

---
