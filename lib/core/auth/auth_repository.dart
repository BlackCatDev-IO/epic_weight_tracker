import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';
import '../local_db.dart';
import 'exceptions/auth_exceptions.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  /// Stream of [User] which will emit the current user or null when
  /// not logged in
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser?.toUser;

      log('$user');
      LocalDb.storeOrUpdateUser(user);
      return user;
    });
  }

  FutureOr<void> _addUserToCollection({required String uid}) {
    return users
        .doc(uid)
        .set({
          'email': currentUser!.email,
        })
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  bool get isLoggedIn => currentUser != null;

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final info = await _firebaseAuth.signInWithCredential(credential);
      LocalDb.storeCredential(credential);
      if (info.additionalUserInfo!.isNewUser) {
        _addUserToCollection(uid: currentUser!.uid);
      }
      log('User logged in via GoogleSignIn');
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (e) {
      log(e.toString());
      throw LogInWithGoogleFailure.fromCode(e.toString());

      // throw const LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  Future<void> deleteUser() async {
    final uid = currentUser!.uid;
    final storedCredential = LocalDb.savedCredential();
    try {
      final result = await currentUser!.reauthenticateWithCredential(
          storedCredential); // handles Firebase 'recent_login_required' exception

      if (storedCredential.signInMethod == 'google.com') {
        await _googleSignIn.disconnect();
      }
      await result.user!.delete();
      await users.doc(uid).delete();
      LocalDb.deleteAll();
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: code: ${e.code} message: ${e.message}');
    } catch (e) {
      log(e.toString());
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: 1, uid: uid, email: email!);
  }
}
