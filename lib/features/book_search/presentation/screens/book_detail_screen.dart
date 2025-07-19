import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/presentation/viewmodels/book_viewmodel.dart';
import 'package:book_finder/features/book_search/presentation/widgets/animated_book_cover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final String bookId;

  const DetailsScreen({required this.bookId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  Book? _book;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    final book = await ref.read(bookViewModelProvider.notifier).getBookDetails(widget.bookId);
    setState(() {
      _book = book;
      _isLoading = false;
      _error = book == null ? 'Failed to load book details' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_error!)),
      );
    }

    final book = _book!;
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBookCover(coverUrl: book.coverUrl),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            Text(book.author ?? 'Unknown', style: Theme.of(context).textTheme.titleMedium),
            if (book.description != null) ...[
              const SizedBox(height: 16),
              Text(book.description!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(bookViewModelProvider.notifier).saveBook(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book saved!')),
                );
              },
              child: const Text('Save Book'),
            ),
          ],
        ),
      ),
    );
  }
}
