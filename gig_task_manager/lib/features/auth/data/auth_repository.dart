import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../domain/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> register(String email, String password);
  Future<void> signOut();
  Stream<UserEntity?> get user;
}

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  FirebaseAuthRepository({fb.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserEntity(uid: user.uid, email: user.email ?? '');
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserEntity?> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        return UserEntity(uid: user.uid, email: user.email ?? '');
      }
      return null;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserEntity?> get user => _firebaseAuth.authStateChanges().map(
        (fb.User? user) =>
            user != null ? UserEntity(uid: user.uid, email: user.email ?? '') : null,
      );
}