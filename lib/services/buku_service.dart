import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buku_model.dart';

class BookService {
  static const String _baseUrl = 'https://openlibrary.org/people/mekBot/books/want-to-read.json';
  static const String _workUrl = 'https://openlibrary.org';

  static Future<List<Book>> fetchWantToReadBooks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final entries = data['reading_log_entries'] as List;

        List<Book> books = [];
        
        for (var entry in entries) {
          try {
            
            Book book = await _createBookWithDetails(entry);
            books.add(book);
          } catch (e) {
            
            books.add(Book.fromJson(entry));
          }
        }

        return books;
      } else {
        throw Exception('Gagal mengambil daftar buku: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  static Future<Book> _createBookWithDetails(Map<String, dynamic> entry) async {
    final work = entry['work'] ?? {};
    String workKey = work['key'] ?? '';
    
   
    Book basicBook = Book.fromJson(entry);
    
    if (workKey.isNotEmpty) {
      try {
        
        final workResponse = await http.get(
          Uri.parse('$_workUrl$workKey.json'),
          headers: {'Accept': 'application/json'},
        );
        
        if (workResponse.statusCode == 200) {
          final workData = json.decode(workResponse.body);
         
          String? description;
          if (workData['description'] != null) {
            if (workData['description'] is String) {
              description = workData['description'];
            } else if (workData['description'] is Map && 
                      workData['description']['value'] != null) {
              description = workData['description']['value'];
            }
          }
          
      
          List<String> subjects = [];
          if (workData['subjects'] != null) {
            subjects = List<String>.from(workData['subjects']);
          }
         
          return Book(
            title: basicBook.title,
            key: basicBook.key,
            authorKeys: basicBook.authorKeys,
            authorNames: basicBook.authorNames,
            firstPublishYear: basicBook.firstPublishYear,
            lendingEdition: basicBook.lendingEdition,
            editionKeys: basicBook.editionKeys,
            coverId: workData['covers']?.isNotEmpty == true 
                ? workData['covers'][0] 
                : basicBook.coverId,
            description: description,
            subjects: subjects,
            category: Book.categorizeBook(subjects, basicBook.title),
          );
        }
      } catch (e) {
     
        print('Failed to fetch work details for ${basicBook.title}: $e');
      }
    }
    
    return basicBook;
  }


  static Future<Book?> fetchBookByWorkKey(String workKey) async {
    try {
      final response = await http.get(
        Uri.parse('$_workUrl$workKey.json'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
    
        String title = data['title'] ?? 'Unknown Title';
        List<String> authorNames = [];
        
        if (data['authors'] != null) {
          for (var author in data['authors']) {
            if (author['author'] != null && author['author']['key'] != null) {
           
              authorNames.add('Author'); // Placeholder
            }
          }
        }
        
        String? description;
        if (data['description'] != null) {
          if (data['description'] is String) {
            description = data['description'];
          } else if (data['description'] is Map && 
                    data['description']['value'] != null) {
            description = data['description']['value'];
          }
        }
        
        List<String> subjects = [];
        if (data['subjects'] != null) {
          subjects = List<String>.from(data['subjects']);
        }
        
        return Book(
          title: title,
          key: workKey,
          authorKeys: [],
          authorNames: authorNames,
          firstPublishYear: data['first_publish_date'] != null 
              ? int.tryParse(data['first_publish_date'].toString().substring(0, 4))
              : null,
          lendingEdition: null,
          editionKeys: [],
          coverId: data['covers']?.isNotEmpty == true ? data['covers'][0] : null,
          description: description,
          subjects: subjects,
          category: Book.categorizeBook(subjects, title),
        );
      }
    } catch (e) {
      print('Error fetching book by work key: $e');
    }
    
    return null;
  }
}