import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/presentation/viewmodels/book_viewmodel.dart';
import 'package:book_finder/features/book_search/presentation/widgets/animated_book_cover.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final Book book;
  const BookDetailsScreen({super.key, required this.book});


  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen>{
  bool _isBookSaved = false;
  Book? _book;
  bool _isLoading = true;
  String? _error;

  Future<void> _fetchBookDetails() async {

    final book = await ref.read(bookViewModelProvider.notifier).getBookDetails(widget.book.id);
    setState(() {
      _book = book;
      _isLoading = false;
      _error = book == null ? 'Failed to load book details' : null;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
    _checkIfBookSaved();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkIfBookSaved() async {
    final saved =await ref.read(bookViewModelProvider.notifier).isBookSaved(widget.book);
    setState(() {
      _isBookSaved = saved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookDetailsAsync = ref.watch(bookViewModelProvider);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              _isBookSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookSaved ? Colors.orange : null,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AnimatedBookCover(coverUrl: widget.book.coverUrl),
            ),
            const SizedBox(height: 32),
            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('by ${widget.book.author}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600],),
            ),
            const SizedBox(height: 24),
            bookDetailsAsync.when(
              data: (detailedBook) {
                if (detailedBook!= null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _book?.description ?? "Description not available",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBookmark() async {
    if (_isBookSaved) {
      await ref.read(bookViewModelProvider.notifier).deleteBook(widget.book);
      setState(() {
        _isBookSaved = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book removed from saved books')),
        );
      }
    } else {
      ref.read(bookViewModelProvider.notifier).saveBook(widget.book);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book saved!')),
      );
      setState(() {
        _isBookSaved = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book saved successfully')),
        );
      }
    }
  }
}