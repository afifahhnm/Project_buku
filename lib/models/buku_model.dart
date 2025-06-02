class Book {
  final String title;
  final String key;
  final List<String> authorKeys;
  final List<String> authorNames;
  final int? firstPublishYear;
  final String? lendingEdition;
  final List<String> editionKeys;
  final int? coverId;
  final String? description;
  final List<String> subjects;
  final String category;

  Book({
    required this.title,
    required this.key,
    required this.authorKeys,
    required this.authorNames,
    this.firstPublishYear,
    this.lendingEdition,
    required this.editionKeys,
    this.coverId,
    this.description,
    this.subjects = const [],
    this.category = 'General',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final work = json['work'] ?? {};

    // Ambil subject dari work, default ke list kosong kalau null
    List<String> subjects = List<String>.from(work['subject'] ?? []);

    // Kategorisasi buku menggunakan method publik categorizeBook
    String category = categorizeBook(subjects, work['title'] ?? '');

    return Book(
      title: work['title'] ?? '',
      key: work['key'] ?? '',
      authorKeys: List<String>.from(work['author_keys'] ?? []),
      authorNames: List<String>.from(work['author_names'] ?? []),
      firstPublishYear: work['first_publish_year'],
      lendingEdition: work['lending_edition_s'],
      editionKeys: List<String>.from(work['edition_key'] ?? []),
      coverId: work['cover_id'],
      description: work['description'] is String
          ? work['description']
          : work['description']?['value'],
      subjects: subjects,
      category: category,
    );
  }

  // Method kategorisasi sekarang PUBLIC (tidak pakai underscore)
  static String categorizeBook(List<String> subjects, String title) {
    String lowerTitle = title.toLowerCase();
    String subjectsStr = subjects.join(' ').toLowerCase();

    if (subjectsStr.contains('fiction') || subjectsStr.contains('novel')) {
      return 'Fiction';
    } else if (subjectsStr.contains('science') || subjectsStr.contains('technology')) {
      return 'Science & Tech';
    } else if (subjectsStr.contains('history') || subjectsStr.contains('biography')) {
      return 'History & Biography';
    } else if (subjectsStr.contains('romance') || lowerTitle.contains('love')) {
      return 'Romance';
    } else if (subjectsStr.contains('mystery') || subjectsStr.contains('thriller')) {
      return 'Mystery & Thriller';
    } else if (subjectsStr.contains('fantasy') || subjectsStr.contains('magic')) {
      return 'Fantasy';
    } else if (subjectsStr.contains('business') || subjectsStr.contains('management')) {
      return 'Business';
    } else if (subjectsStr.contains('self') || subjectsStr.contains('motivation')) {
      return 'Self Help';
    } else {
      return 'General';
    }
  }


  String? get coverUrl {
    if (coverId != null) {
      return 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    }
    return null;
  }


  String? get coverUrlByEdition {
    if (editionKeys.isNotEmpty) {
      return 'https://covers.openlibrary.org/b/olid/${editionKeys.first}-L.jpg';
    }
    return null;
  }


  String? get thumbnailUrl {
    if (coverId != null) {
      return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    } else if (editionKeys.isNotEmpty) {
      return 'https://covers.openlibrary.org/b/olid/${editionKeys.first}-M.jpg';
    }
    return null;
  }
}