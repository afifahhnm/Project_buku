import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.shade400.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple.shade300),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.purple.shade200,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple.shade300, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade900,
                    Colors.purple.shade800,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade800,
                            Colors.deepPurple.shade900,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.6),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 60),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Book Lover',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade200,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'bookworm@example.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple.shade300,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Menu Items
                    _buildProfileMenuItem(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      subtitle: 'Update your info',
                      onTap: () {},
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.bookmark,
                      title: 'My Bookmarks',
                      subtitle: 'View saved books',
                      onTap: () {},
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      subtitle: 'Your top books',
                      onTap: () {},
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'App version',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.deepPurple.shade900,
                            title: const Text('About App', style: TextStyle(color: Colors.white)),
                            content: Text(
                              'Book Library v1.0.0\n\nA beautifully designed app to explore and manage your favorite books.',
                              style: TextStyle(color: Colors.purple.shade200),
                            ),
                            actions: [
                              TextButton(
                                child: Text('OK', style: TextStyle(color: Colors.purple.shade300)),
                                onPressed: () => Navigator.of(ctx).pop(),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    _buildProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      subtitle: 'Sign out from app',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: Colors.deepPurple.shade900,
                            title: const Text('Logout', style: TextStyle(color: Colors.white)),
                            content: Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(color: Colors.purple.shade200),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel', style: TextStyle(color: Colors.purple.shade300)),
                                onPressed: () => Navigator.of(ctx).pop(),
                              ),
                              TextButton(
                                child: const Text('Logout', style: TextStyle(color: Colors.red)),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Logged out'),
                                      backgroundColor: Colors.purple.shade800,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
