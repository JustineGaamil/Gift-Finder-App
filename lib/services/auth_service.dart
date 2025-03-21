import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Box<User> get _userBox => Hive.box<User>('users');
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check if user already exists
      if (_userBox.values.any((user) => user.email == email)) {
        return false;
      }

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        password: password, // In a real app, this should be hashed
        name: name,
        createdAt: DateTime.now(),
      );

      await _userBox.put(user.id, user);
      _currentUser = user;
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = _userBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw 'User not found',
      );

      _currentUser = user;
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  Future<void> clearUsers() async {
    await _userBox.clear();
    _currentUser = null;
  }
}
