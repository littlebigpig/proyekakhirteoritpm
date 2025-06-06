import 'package:flutter_test/flutter_test.dart';
import 'package:tugas2teori/models/country.dart';
import 'package:tugas2teori/services/database_helper.dart';
import 'package:tugas2teori/models/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbHelper = DatabaseHelper();

  group('DatabaseHelper', () {
    test('Register and verify user', () async {
      // Register user
      final user = User(name: 'testuser1', email: 'test1@mail.com', password: '1234');
      await dbHelper.insertUser(user);

      // Verify user
      final result = await dbHelper.verifyUser('testuser1', '1234');
      expect(result, isNotNull);
      expect(result?.name, 'testuser1');
      expect(result?.email, 'test1@mail.com');
    });

    test('Fail login with wrong password', () async {
      final result = await dbHelper.verifyUser('testuser1', 'wrongpass');
      expect(result, isNull);
    });

    test('Prevent duplicate username', () async {
      final user1 = User(name: 'dupuser1', email: 'dup1@mail.com', password: 'pass');
      final user2 = User(name: 'dupuser1', email: 'dup2@mail.com', password: 'pass');
      await dbHelper.insertUser(user1);
      final isTaken = await dbHelper.isUsernameTaken('dupuser1');
      expect(isTaken, isTrue);
    });

    test('Prevent duplicate email', () async {
      final user1 = User(name: 'userA1', email: 'dupemail1@mail.com', password: 'pass');
      final user2 = User(name: 'userB1', email: 'dupemail1@mail.com', password: 'pass');
      await dbHelper.insertUser(user1);
      final isTaken = await dbHelper.isEmailTaken('dupemail1@mail.com');
      expect(isTaken, isTrue);
    });

    test('Update user profile', () async {
      final user = User(name: 'editme1', email: 'edit1@mail.com', password: 'pass');
      await dbHelper.insertUser(user);
      final inserted = await dbHelper.verifyUser('editme1', 'pass');
      final updatedUser = User(
        id: inserted!.id,
        name: 'edited1',
        email: 'edited1@mail.com',
        password: inserted.password,
      );
      final success = await dbHelper.updateUser(updatedUser);
      expect(success, isTrue);
      final result = await dbHelper.verifyUser('edited1', 'pass');
      expect(result, isNotNull);
      expect(result?.email, 'edited1@mail.com');
    });

    test('Delete user', () async {
      final user = User(name: 'todelete1', email: 'del1@mail.com', password: 'pass');
      await dbHelper.insertUser(user);
      final inserted = await dbHelper.verifyUser('todelete1', 'pass');
      final deleted = await dbHelper.deleteUser(inserted!.id!);
      expect(deleted, isTrue);
      final result = await dbHelper.verifyUser('todelete1', 'pass');
      expect(result, isNull);
    });

    test('Get all users', () async {
      await dbHelper.insertUser(User(name: 'user12', email: 'unique12@mail.com', password: 'pass'));
      await dbHelper.insertUser(User(name: 'user22', email: 'unique22@mail.com', password: 'pass'));
      final users = await dbHelper.getAllUsers();
      expect(users.length, greaterThanOrEqualTo(2));
    });
  });

  // Example country search function
  List<CountryStats> searchCountries(List<CountryStats> countries, String query) {
    return countries
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Unit test
  test('Country search returns correct results', () {
    final countries = [
      CountryStats(name: 'Indonesia', gdp: 0.0, currency: Currency(code: 'IDR', name: 'Rupiah'), iso2: '', capital: '', population: 0, telephoneCountryCodes: [], timezones: [],),
      CountryStats(name: 'India', gdp: 0.0, currency: Currency(code: 'INR', name: 'Rupee'), iso2: '', capital: '', population: 0, telephoneCountryCodes: [], timezones: [],),
      CountryStats(name: 'Canada', gdp: 0.0, currency: Currency(code: 'CAD', name: 'Canadian Dollar'), iso2: '', capital: '', population: 0, telephoneCountryCodes: [], timezones: [],),
    ];
    final result = searchCountries(countries, 'Ind');
    expect(result.length, 2);
    expect(result.any((c) => c.name == 'Indonesia'), isTrue);
    expect(result.any((c) => c.name == 'India'), isTrue);
  });

  double convertCurrency(double amount, double rate) {
    return amount * rate;
  }

  // Unit test
  test('Currency conversion is correct', () {
    expect(convertCurrency(10, 15000), 150000);
    expect(convertCurrency(0, 15000), 0);
    expect(convertCurrency(100, 1.5), 150);
  });

  String formatLocation(double lat, double lng) {
    return 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
  }

  // Unit test
  test('Location formatting', () {
    expect(formatLocation(-6.2, 106.8), 'Lat: -6.2000, Lng: 106.8000');
  });

  bool isShake(double dx, double dy, double dz, double threshold) {
    return dx > threshold || dy > threshold || dz > threshold;
  }

  // Unit test
  test('Shake detection logic', () {
    expect(isShake(16, 1, 1, 15), isTrue);
    expect(isShake(1, 16, 1, 15), isTrue);
    expect(isShake(1, 1, 16, 15), isTrue);
    expect(isShake(1, 1, 1, 15), isFalse);
  });
}

