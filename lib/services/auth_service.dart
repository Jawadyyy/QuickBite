import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fb = FirebaseAuth.instance;

  Future<User?> signIn(String email, String pass) async {
    try {
      final userCredential = await _fb.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<User?> signUp(String email, String pass) async {
    try {
      final userCredential = await _fb.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e));
    }
  }

  Future<void> signOut() async => await _fb.signOut();

  Stream<User?> get userChanges => _fb.authStateChanges();

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-not-found':
        return 'User not found.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return 'Something went wrong. (${e.message})';
    }
  }
}
