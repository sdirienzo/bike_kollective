import 'package:firebase_auth/firebase_auth.dart';

// Class built based on logic outlined here:
// https://medium.com/flutterpub/flutter-how-to-do-user-login-with-firebase-a6af760b14d5
class AuthenticationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user != null ? user.uid : null;
  }

  Future<String> register(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user != null ? user.uid : null;
  }

  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _auth.currentUser();
    return user.uid;
  }

  Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
