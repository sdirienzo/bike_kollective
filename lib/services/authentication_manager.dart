import 'package:firebase_auth/firebase_auth.dart';

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

  Future<String> getCurrentUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    return user.email;
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
