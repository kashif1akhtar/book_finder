class Book {
  final String id;
  final String title;
  final String? author;
  final String? coverUrl;
  final String? description;

  Book({required this.id, required this.title, this.author, this.coverUrl, this.description});
}