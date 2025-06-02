import 'package:flutter/material.dart';
import '../models/buku_model.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: CustomScrollView(
        slivers: [
          // App Bar dengan Cover Buku
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.deepPurple.shade900,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade900,
                      Colors.purple.shade800,
                      const Color(0xFF0A0A1A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Space for status bar
                    // Book Cover
                    Container(
                      width: 180,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: book.coverUrl != null || book.coverUrlByEdition != null
                            ? Image.network(
                                book.coverUrl ?? book.coverUrlByEdition!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.purple.shade700,
                                    child: const Icon(
                                      Icons.book,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: Colors.purple.shade700,
                                child: const Icon(
                                  Icons.book,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Authors
                  Text(
                    book.authorNames.isNotEmpty
                        ? 'by ${book.authorNames.join(', ')}'
                        : 'Author unknown',
                    style: TextStyle(
                      color: Colors.purple.shade300,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // kategori dan tahun
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade600,
                              Colors.deepPurple.shade700,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          book.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (book.firstPublishYear != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade800.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Published ${book.firstPublishYear}',
                            style: TextStyle(
                              color: Colors.purple.shade200,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Synopsis Section
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade900.withOpacity(0.3),
                          Colors.deepPurple.shade900.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade700.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      book.description ?? 
                      'Synopsis not available for this book. This book appears to be part of your reading list and may contain interesting content worth exploring.',
                      style: TextStyle(
                        color: Colors.purple.shade100,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Subjects/Tags
                  if (book.subjects.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: book.subjects.take(10).map((subject) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.shade800.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.purple.shade600.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            subject,
                            style: TextStyle(
                              color: Colors.purple.shade200,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Book Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.shade900.withOpacity(0.3),
                          Colors.deepPurple.shade900.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.purple.shade700.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Book Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Book Key', book.key),
                        if (book.editionKeys.isNotEmpty)
                          _buildInfoRow('Editions', '${book.editionKeys.length} available'),
                        if (book.lendingEdition != null)
                          _buildInfoRow('Lending', book.lendingEdition!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add to favorites or reading progress
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added to reading progress!'),
              backgroundColor: Colors.purple.shade600,
            ),
          );
        },
        backgroundColor: Colors.purple.shade600,
        icon: const Icon(Icons.bookmark_add, color: Colors.white),
        label: const Text(
          'Start Reading',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.purple.shade300,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.purple.shade100,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}