import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      _errorMessage = null;
      notifyListeners();
    });
  }

  /// Sign up with email and password
  Future<bool> signUp(String email, String password, String displayName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('[AuthProvider] 🔄 Attempting sign up: $email');

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('[AuthProvider] ✅ User created: ${userCredential.user?.uid}');

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);
      await userCredential.user?.reload();

      _user = _firebaseAuth.currentUser;
      _isLoading = false;
      notifyListeners();
      print('[AuthProvider] ✅ Sign up successful');
      return true;
    } on FirebaseAuthException catch (e) {
      print('[AuthProvider] ❌ FirebaseAuthException: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('[AuthProvider] ❌ Unknown error: $e');
      _errorMessage = 'Erreur inconnue: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('[AuthProvider] 🔄 Attempting sign in: $email');

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = _firebaseAuth.currentUser;
      _isLoading = false;
      notifyListeners();
      print('[AuthProvider] ✅ Sign in successful: ${_user?.email}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('[AuthProvider] ❌ FirebaseAuthException: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('[AuthProvider] ❌ Unknown error: $e');
      _errorMessage = 'Erreur inconnue: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseAuth.signOut();
      _user = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors de la déconnexion';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Password reset
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      _isLoading = false;
      _errorMessage = 'Email de réinitialisation envoyé';
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get user-friendly error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'user-not-found':
        return 'Utilisateur non trouvé';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'user-disabled':
        return 'Compte désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      default:
        return 'Une erreur s\'est produite. Veuillez réessayer';
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
