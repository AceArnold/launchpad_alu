import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Creates a new account, then writes a matching user profile to Firestore.
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required String role, // "student" or "startup"
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final appUser = AppUser(
      uid: uid,
      email: email,
      role: role,
      name: name,
      createdAt: DateTime.now(),
    );

    await _db.collection('users').doc(uid).set(appUser.toMap());

    // If they're signing up as a startup, also create a starter startup profile
    if (role == 'startup') {
      await _db.collection('startups').doc(uid).set({
        'ownerUid': uid,
        'name': name,
        'description': '',
        'category': 'Other',
        'isVerified': false,
        'createdAt': DateTime.now(),
      });
    }

    return appUser;
  }

  /// Logs in an existing user and fetches their profile (including role) from Firestore.
  Future<AppUser> logIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final doc = await _db.collection('users').doc(uid).get();

    if (!doc.exists) {
      throw Exception('User profile not found in database.');
    }

    return AppUser.fromMap(doc.data()!);
  }

  /// Fetches the current logged-in user's profile — used by Splash screen
  /// to decide where to route someone who's already logged in.
  Future<AppUser?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  /// Converts Firebase's raw error codes into friendly messages for the UI.
  String getErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Password is too weak (min 6 characters).';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        default:
          return error.message ?? 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}