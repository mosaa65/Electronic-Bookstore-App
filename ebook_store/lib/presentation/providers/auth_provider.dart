import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  AuthProvider() {
    _initializeUser();
    // Listen to auth state changes
    _authRepository.authStateChanges.listen((User? user) {
      if (user == null) {
        _currentUser = null;
        notifyListeners();
      } else if (_currentUser == null) {
        // If user is logged in but local state is null, fetch data
        _initializeUser();
      }
    });
  }

  // Initialize user from Firebase
  Future<void> _initializeUser() async {
    print('DEBUG: _initializeUser called');
    final user = _authRepository.currentUser;
    print('DEBUG: Current Firebase User: ${user?.uid}');

    if (user != null) {
      try {
        print('DEBUG: Fetching user data from Firestore...');
        _currentUser = await _authRepository.getUserData(user.uid);
        print('DEBUG: Firestore Data: ${_currentUser != null ? "Found" : "Not Found"}');

        if (_currentUser == null) {
            // Fallback if Firestore fails: create partial user from Auth
            print('DEBUG: Firestore user data missing, using Auth data');
            _currentUser = UserModel(
               uid: user.uid,
               email: user.email ?? '',
               displayName: user.displayName ?? 'مستخدم',
               role: 'user',
               createdAt: DateTime.now(),
               updatedAt: DateTime.now(),
               photoURL: user.photoURL,
            );
        }
      } catch (e) {
         print('DEBUG: Error in _initializeUser: $e');
      }
      notifyListeners();
    }
  }

  // Sign in with email
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    print('DEBUG: Attempting login for $email');

    try {
      final user = await _authRepository.signInWithEmail(email, password);
      print('DEBUG: Auth successful for ${user?.uid}');
      
      if (user != null) {
        await _initializeUser();
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'فشل تسجيل الدخول: مستخدم غير موجود';
        print('DEBUG: Login failed: User is null');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('DEBUG: Login exception: $e');
      _setLoading(false);
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String displayName,
    String role = 'user',
  }) async {
    _setLoading(true);
    _errorMessage = null;
    print('DEBUG: Attempting register for $email');

    try {
      final user = await _authRepository.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );
      
      print('DEBUG: Auth return handled: ${user?.uid}');

      if (user != null) {
        _currentUser = user;
        notifyListeners();
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'فشل إنشاء الحساب';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('DEBUG: Register exception: $e');
      _setLoading(false);
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _currentUser = await _authRepository.signInWithGoogle();
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
    }
  }

  // Update user data
  Future<bool> updateUserData(UserModel user) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authRepository.updateUserData(user);
      _currentUser = user;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authRepository.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// إنشاء مدير جديد بواسطة مدير حالي
  /// متاحة فقط للمدراء
  Future<bool> createAdminByAdmin({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // التحقق من أن المستخدم الحالي مدير
    if (!isAdmin) {
      _errorMessage = 'غير مصرح لك بإنشاء مدراء';
      return false;
    }
    
    _setLoading(true);
    _errorMessage = null;
    
    try {
      final newAdmin = await _authRepository.createAdminByAdmin(
        email: email,
        password: password,
        displayName: displayName,
        createdBy: _currentUser!.uid,
      );
      
      _setLoading(false);
      return newAdmin != null;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// جلب قائمة المدراء
  Future<List<dynamic>> getAdminsList() async {
    try {
      return await _authRepository.getAdminsList();
    } catch (e) {
      _errorMessage = e.toString();
      return [];
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
