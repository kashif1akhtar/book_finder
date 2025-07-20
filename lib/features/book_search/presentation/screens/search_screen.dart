import 'package:book_finder/core/util/custom_snackbar.dart';
import 'package:book_finder/features/book_search/domain/entities/book_entity.dart';
import 'package:book_finder/features/book_search/presentation/screens/book_detail_screen.dart';
import 'package:book_finder/features/book_search/presentation/providers/book_provider.dart';
import 'package:book_finder/features/book_search/presentation/widgets/book_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          !ref.read(bookProvider.notifier).isLoadingMore) {
        ref.read(bookProvider.notifier).loadMore(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(bookProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Finder'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search for books...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  ref.read(bookProvider.notifier).searchBooks(
                      value, isRefresh: true);
                }
                else {
                    TopSnackbarHelper.show(context, 'Enter some book name!');
                }
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(bookProvider.notifier)
                  .searchBooks(_controller.text, isRefresh: true),
              child: _buildContent(booksState,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<Book>> booksState) {
    return booksState.when(
      data: (books) {
        if (books.isEmpty && _controller.text.isNotEmpty ) {
          return _buildEmptyState();
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              book: book,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookDetailsScreen(book: book),
                ),
              ),
            );
          },
        );
      },
      loading: () => _buildShimmerCard(),
      error: (error, _) => _buildErrorWidget(booksState),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, __) => ListTile(
              leading: Container(width: 50, height: 50, color: Colors.white),
              title: Container(width: double.infinity, height: 16, color: Colors.white),
              subtitle: Container(width: double.infinity, height: 12, color: Colors.white),
            )));
  }

  Widget _buildErrorWidget(state)
  {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: ${state.error}',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(bookProvider.notifier).searchBooks(_controller.text, isRefresh: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.blueAccent,
          ),
          SizedBox(height: 16),
          Text(
            'No books found for your search',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}