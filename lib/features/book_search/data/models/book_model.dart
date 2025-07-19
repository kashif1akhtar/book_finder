class BookModel {
  final String id;
  final String title;
  final String? author;
  final String? coverUrl;
  final String? description;

  BookModel({required this.id, required this.title, this.author, this.coverUrl, this.description});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['key'] ?? '',
      title: json['title'] ?? 'Unknown',
      author: json['author_name']?.join(', ') ??
          (json['authors']?.isNotEmpty == true ? json['authors'][0]['author']['key'] : null) ?? 'Unknown',
      coverUrl: json['covers']?.isNotEmpty == true
          ? 'https://covers.openlibrary.org/b/id/${json['covers'][0]}-M.jpg'
          : json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg'
          : null,
      description: json['description'] is String
          ? json['description']
          : json['description']?['value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    };
  }
}
