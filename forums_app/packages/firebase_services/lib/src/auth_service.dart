import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  // Constructor accepts optional FirebaseAuth (makes testing with mockito easy)
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  // Returns the currently logged-in user (null if not logged in)
  User? get currentUser => _auth.currentUser;

  // Stream that updates whenever auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register a new user
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login existing user
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> signOut() {
    return _auth.signOut();
  }
}