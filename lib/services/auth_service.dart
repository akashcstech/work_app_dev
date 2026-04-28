import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Set to true only after Firebase.initializeApp() succeeds
  static bool firebaseReady = false;

  // Local auth state for web demo (when Firebase not configured)
  final ValueNotifier<bool> webLoggedIn = ValueNotifier(false);
  void webLogin() => webLoggedIn.value = true;
  void webLogout() => webLoggedIn.value = false;

  // Safely returns FirebaseAuth — null if not initialized
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  Stream<User?> authStateChanges() {
    try {
      return _auth?.authStateChanges() ?? const Stream.empty();
    } catch (_) {
      return const Stream.empty();
    }
  }

  User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    final cred = await _auth!.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user;
  }

  Future<User?> signUp(String email, String password) async {
    final cred = await _auth!.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user;
  }

  Future<void> signOut() async {
    try {
      await _auth?.signOut();
    } catch (_) {}
  }
}
