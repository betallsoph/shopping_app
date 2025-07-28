import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';

class AuthState extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  AuthState() {
    AuthService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
    
    _user = AuthService.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await AuthService.signInWithGoogle();
      if (userCredential != null) {
        _user = userCredential.user;
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.signOut();
      _user = null;
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void login() {
    signInWithGoogle();
  }

  void logout() {
    signOut();
  }
}