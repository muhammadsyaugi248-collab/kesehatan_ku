import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kesehatan_ku/models/userfirebasemodel.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<Userfirebasemodel> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    final model = Userfirebasemodel(
      uid: user.uid,
      username: username,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );
    await firestore.collection("users").doc(user.uid).set(model.toMap());
    return model;
  }

  static Future<Userfirebasemodel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) return null;

      final snap = await firestore.collection('users').doc(user.uid).get();
      if (!snap.exists) return null;

      return Userfirebasemodel.fromMap({'uid': user.uid, ...snap.data()!});
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential" ||
          e.code == "wrong-password" ||
          e.code == "user-not-found") {
        return null;
      }
      print("FirebaseAuthException: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("Unknown login error: $e");
      return null;
    }
  }
}
