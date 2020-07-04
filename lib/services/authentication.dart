import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user != null ? user.uid : null;
  }
}
