import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas2teori/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/database_helper.dart';
import '../models/user.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  User? _currentUser;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _profilePicturePath;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      
      if (username != null && username.isNotEmpty) {
        final user = await _dbHelper.getUserByName(username);
        if (mounted) {
          setState(() {
            _currentUser = user;
            _nameController.text = user?.name ?? "";
            _emailController.text = user?.email ?? "";
            _profilePicturePath = user?.profilePicturePath;
          });
        }
      }
    } catch (e) {
      print('Error loading user: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user data')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    if (_currentUser == null || !_isEditing) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null && mounted) {
        setState(() => _isLoading = true);
        
        // Validate if file exists and is accessible
        final file = File(image.path);
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }
        
        // Save image path to database
        final success = await _dbHelper.updateProfilePicture(
          _currentUser!.id!,
          image.path,
        );

        if (success && mounted) {
          setState(() {
            _profilePicturePath = image.path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile picture updated successfully')),
          );
        } else {
          throw Exception('Failed to save profile picture');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_currentUser == null || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final newName = _nameController.text.trim();
      final newEmail = _emailController.text.trim();
      
      // Validate inputs
      if (newName.isEmpty || newEmail.isEmpty) {
        throw Exception('Name and email cannot be empty');
      }
      
      if (!_isValidEmail(newEmail)) {
        throw Exception('Please enter a valid email address');
      }

      // Check if username is taken by another user
      if (newName != _currentUser!.name) {
        final isTaken = await _dbHelper.isUsernameTaken(newName);
        if (isTaken) {
          throw Exception('Username is already taken');
        }
      }

      // Check if email is taken by another user
      if (newEmail != _currentUser!.email) {
        final isTaken = await _dbHelper.isEmailTaken(newEmail);
        if (isTaken) {
          throw Exception('Email is already taken');
        }
      }

      final updatedUser = User(
        id: _currentUser!.id,
        name: newName,
        email: newEmail,
        password: _currentUser!.password,
        profilePicturePath: _profilePicturePath,
      );

      final success = await _dbHelper.updateUser(updatedUser);

      if (success) {
        // Update SharedPreferences with new username
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', updatedUser.name);

        if (mounted) {
          setState(() {
            _currentUser = updatedUser;
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } else {
        throw Exception('Failed to update profile in database');
      }
    } catch (e) {
      print('Error updating profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _logout() async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        
        if (mounted) {
          // Navigate to login page and remove all previous routes
          context.go('/login');
        }
      }
    } catch (e) {
      print('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout')),
        );
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Reset form to original values
      _nameController.text = _currentUser?.name ?? "";
      _emailController.text = _currentUser?.email ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          if (!_isLoading && _currentUser != null) ...[
            if (_isEditing) ...[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: _cancelEdit,
                tooltip: 'Cancel',
              ),
              IconButton(
                icon: Icon(Icons.save),
                onPressed: _updateProfile,
                tooltip: 'Save',
              ),
            ] else
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => setState(() => _isEditing = true),
                tooltip: 'Edit',
              ),
          ],
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            )
          : _currentUser == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No user data found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUser,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildProfilePicture(),
                          SizedBox(height: 24),

                          // User Info
                          if (_isEditing) ...[
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: Colors.white,
                                helperText: '2-10 karakter',
                              ),
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                if (value.trim().length < 2) {
                                  return 'Username minimal 2 karakter';
                                }
                                if (value.trim().length > 10) {
                                  return 'Username maksimal 10 karakter';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.email),
                                filled: true,
                                fillColor: Colors.white,
                                helperText: 'Maksimal 254 karakter',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 254,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!_isValidEmail(value.trim())) {
                                  return 'Format email tidak valid';
                                }
                                if (value.trim().length > 254) {
                                  return 'Email terlalu panjang';
                                }
                                return null;
                              },
                            ),
                          ] else ...[
                            Text(
                              _currentUser?.name ?? "User",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _currentUser?.email ?? "email@example.com",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],

                          SizedBox(height: 32),

                          // Action Buttons
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => context.push(Routes.NestedBantuanPage),
                              icon: Icon(Icons.help, size: 20),
                              label: Text('Bantuan'),
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _logout,
                              icon: Icon(Icons.logout, color: Colors.red, size: 20),
                              label: Text('Log out'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: BorderSide(color: Colors.red),
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _isEditing ? _pickImage : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: _profilePicturePath != null && _profilePicturePath!.isNotEmpty
                  ? FileImage(File(_profilePicturePath!))
                  : null,
              onBackgroundImageError: _profilePicturePath != null && _profilePicturePath!.isNotEmpty
                  ? (e, stackTrace) {
                      print('Error loading profile picture: $e');
                      setState(() {
                        _profilePicturePath = null;
                      });
                      if (_currentUser != null) {
                        _dbHelper.updateProfilePicture(_currentUser!.id!, '');
                      }
                    }
                  : null,
              child: _profilePicturePath == null || _profilePicturePath!.isEmpty
                  ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                  : null,
            ),
          ),
          if (_isEditing)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}