import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<bool> isDatabaseExists() async {
    try {
      String path = await _getDatabasePath();
      return File(path).exists();
    } catch (e) {
      print('Error checking if database exists: $e');
      return false;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      String path = await _getDatabasePath();
      await File(path).delete();
      _database = null;
    } catch (e) {
      print('Error deleting database: $e');
    }
  }

  Future<String> _getDatabasePath() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'user_database.db');
      
      // Ensure the directory exists
      final dir = Directory(dirname(path));
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      
      return path;
    } catch (e) {
      print('Error getting database path: $e');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      String path = await _getDatabasePath();
      print('Database path: $path');
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          print('Creating database tables...');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT UNIQUE,
              email TEXT UNIQUE,
              password TEXT,
              profile_picture TEXT
            )
          ''');
          print('Database tables created successfully');
        },
        onOpen: (db) async {
          print('Database opened successfully');
          try {
            await db.query('users');
            print('Users table exists and is accessible');
          } catch (e) {
            print('Error accessing users table: $e');
            // Try to recreate the table if there's an error
            await db.execute('''
              CREATE TABLE IF NOT EXISTS users(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT UNIQUE,
                email TEXT UNIQUE,
                password TEXT,
                profile_picture TEXT
              )
            ''');
          }
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  // Hash password using SHA-256
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Insert a new user
  Future<bool> insertUser(User user) async {
    try {
      print('Attempting to insert user: ${user.name}');
      final Database db = await database;
      final hashedPassword = _hashPassword(user.password);
      
      final userData = {
        'name': user.name,
        'email': user.email,
        'password': hashedPassword,
        'profile_picture': user.profilePicturePath,
      };
      print('User data prepared: $userData');
      
      await db.insert(
        'users',
        userData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      print('User inserted successfully');
      return true;
    } catch (e) {
      print('Error inserting user: $e');
      if (e is DatabaseException) {
        print('SQLite error code: ${e.getResultCode()}');
      }
      return false;
    }
  }

  // Verify user login
  Future<User?> verifyUser(String name, String password) async {
    try {
      final Database db = await database;
      final hashedPassword = _hashPassword(password);
      
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'name = ? AND password = ?',
        whereArgs: [name, hashedPassword],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error verifying user: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUser(User user) async {
    try {
      final Database db = await database;
      await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Update user profile picture
  Future<bool> updateProfilePicture(int userId, String picturePath) async {
    try {
      final Database db = await database;
      // Convert to platform-specific path
      final normalizedPath = picturePath.replaceAll(RegExp(r'[/\\]+'), Platform.pathSeparator);
      
      await db.update(
        'users',
        {'profile_picture': normalizedPath},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (e) {
      print('Error updating profile picture: $e');
      return false;
    }
  }

  // Get user by name
  Future<User?> getUserByName(String name) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'name = ?',
        whereArgs: [name],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Check if username exists
  Future<bool> isUsernameTaken(String name) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'name = ?',
        whereArgs: [name],
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  // Check if email exists
  Future<bool> isEmailTaken(String email) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      return maps.isNotEmpty;
    } catch (e) {
      print('Error checking email: $e');
      return false;
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // Delete a user
  Future<bool> deleteUser(int id) async {
    try {
      final db = await database;
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}