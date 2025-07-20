# Book Finder App

A Flutter application that allows users to search for books using the Open Library API, view book details, and save books locally using SQLite.

## Features

### Main Features
- **Search Books**: Search for books by title using the Open Library API
- **Book Details**: View detailed information about books with animated cover
- **Save Books**: Save books locally using SQLite database
- **Pull to Refresh**: Refresh search results with pull-to-refresh gesture
- **Pagination**: Load more results as user scrolls till 90 percent of the listing screen
- **Shimmer Loading**: Beautiful loading animations while fetching data

### Technical Implementation
- **Clean Architecture**: Separation of concerns with Data, Domain, and Presentation layers -- with view model
- **State Management**: Riverpod for reactive state management with viewmodel
- **Database**: SQLite for local storage
- **Network**: Dio for HTTP requests
- **Animations**: Custom book cover rotation animation
- **Error Handling**: Error handling classes 
- **Unit Testing**: Tests for repository and provider logic


## API Integration

The app integrates with the Open Library API:
- **Search Endpoint**: `https://openlibrary.org/search.json`
- **Book Details**: `https://openlibrary.org/works/{id}.json`
- **Cover Images**: `https://covers.openlibrary.org/b/id/{cover_id}-M.jpg`

## State Management

Uses Riverpod for state management with the following view model:
- `bookViewModel`: Manages search state and pagination, Fetches detailed book information, Manages locally saved books

## Database Schema

SQLite table structure:
```sql
CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, author TEXT, coverUrl TEXT, description TEXT)
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio
- Android device or emulator
- Xcode 

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

## Dependencies

### Main Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `sqflite`: SQLite database
- `shimmer`: Loading animations
- `cached_network_image`: Image caching
- `equatable`: Value equality
- `json_annotation`: JSON serialization
- `get_it` : For dependency injection

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
- Unit tests for repository 


## License

This project is licensed under the MIT License.

---
