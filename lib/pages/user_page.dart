import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/buku_model.dart';
import '../services/buku_service.dart';
import 'buku_detail.dart';
import 'profile_page.dart';

class BookDashboard extends StatefulWidget {
  const BookDashboard({super.key});

  @override
  State<BookDashboard> createState() => _BookDashboardState();
}

class _BookDashboardState extends State<BookDashboard> {
  late Future<List<Book>> _futureBooks;
  String _selectedCategory = 'All';
  int _currentPageIndex = 0; 
  
 
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  List<Book> _allBooks = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _futureBooks = BookService.fetchWantToReadBooks();
    _loadAllBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllBooks() async {
    try {
      final books = await BookService.fetchWantToReadBooks();
      setState(() {
        _allBooks = books;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _allBooks.where((book) {
        return book.title.toLowerCase().contains(query.toLowerCase()) ||
               book.authorNames.any((author) => 
                 author.toLowerCase().contains(query.toLowerCase()));
      }).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  List<String> _getCategories(List<Book> books) {
    Set<String> categories = {'All'};
    for (var book in books) {
      categories.add(book.category);
    }
    return categories.toList();
  }

  List<Book> _filterBooks(List<Book> books) {
    if (_selectedCategory == 'All') return books;
    return books.where((book) => book.category == _selectedCategory).toList();
  }

  Widget _buildGlassmorphicContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double borderRadius = 20,
    double opacity = 0.15,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(opacity),
            Colors.white.withOpacity(opacity * 0.5),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: _buildGlassmorphicContainer(
        borderRadius: 25,
        opacity: isSelected ? 0.3 : 0.1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _buildGlassmorphicContainer(
        borderRadius: 24,
        opacity: 0.1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailPage(book: book),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Book Cover with Glassmorphic Effect
                  _buildGlassmorphicContainer(
                    width: 70,
                    height: 100,
                    borderRadius: 16,
                    opacity: 0.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: book.thumbnailUrl != null
                          ? Image.network(
                              book.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF6366F1),
                                        const Color(0xFF8B5CF6),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF6366F1),
                                    const Color(0xFF8B5CF6),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Book Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          book.authorNames.isNotEmpty
                              ? book.authorNames.join(', ')
                              : 'Tidak diketahui',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildGlassmorphicContainer(
                              borderRadius: 16,
                              opacity: 0.2,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Text(
                                book.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (book.firstPublishYear != null)
                              Text(
                                '${book.firstPublishYear}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: _buildGlassmorphicContainer(
        borderRadius: 20,
        opacity: 0.1,
        child: TextField(
          controller: _searchController,
          onChanged: _performSearch,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: 'Cari judul buku atau nama penulis...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.white.withOpacity(0.7),
              size: 24,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F0F23),
          ],
        ),
      ),
      child: Column(
        children: [
          // Header with Glassmorphic Effect
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Library',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover your next favorite book',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Categories
          Container(
            height: 60,
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                
                final categories = _getCategories(snapshot.data!);
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryChip(
                      category,
                      category == _selectedCategory,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Books List
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF8B5CF6),
                      strokeWidth: 3,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: _buildGlassmorphicContainer(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(30),
                      opacity: 0.1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 64,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Terjadi kesalahan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: _buildGlassmorphicContainer(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(30),
                      opacity: 0.1,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.library_books_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: 64,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Tidak ada buku ditemukan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final filteredBooks = _filterBooks(snapshot.data!);

                return ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    return _buildBookCard(filteredBooks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F0F23),
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Books',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find your perfect book',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Search Bar
          _buildSearchBar(),
          // Search Results
          Expanded(
            child: _isSearching
                ? Center(
                    child: CircularProgressIndicator(
                      color: const Color(0xFF8B5CF6),
                      strokeWidth: 3,
                    ),
                  )
                : !_hasSearched
                    ? Center(
                        child: _buildGlassmorphicContainer(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(40),
                          opacity: 0.1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_rounded,
                                size: 80,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Cari Buku Favorit Anda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                    
                            ],
                          ),
                        ),
                      )
                    : _searchResults.isEmpty
                        ? Center(
                            child: _buildGlassmorphicContainer(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(40),
                              opacity: 0.1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 80,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Tidak Ada Hasil',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Coba gunakan kata kunci yang berbeda\natau periksa ejaan Anda',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              return _buildBookCard(_searchResults[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      extendBody: true,
      body: SafeArea(
        child: _currentPageIndex == 0
            ? _buildLibraryPage()
            : _buildSearchPage(),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: _buildGlassmorphicContainer(
          height: 70,
          borderRadius: 25,
          opacity: 0.15,
          child: BottomNavigationBar(
            currentIndex: _currentPageIndex,
            onTap: (index) {
              if (index == 2) {
                // Navigate to ProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              } else {
                setState(() {
                  _currentPageIndex = index;
                  // Reset search when switching pages
                  if (index != 1) {
                    _searchController.clear();
                    _searchResults.clear();
                    _hasSearched = false;
                  }
                });
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_rounded, size: 24),
                activeIcon: Icon(Icons.library_books_rounded, size: 28),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded, size: 24),
                activeIcon: Icon(Icons.search_rounded, size: 28),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 24),
                activeIcon: Icon(Icons.person_rounded, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}