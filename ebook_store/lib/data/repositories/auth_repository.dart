import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      print('DEBUG REPO: Calling signInWithEmailAndPassword...');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('DEBUG REPO: signInWithEmailAndPassword returned. User: ${credential.user?.uid}');

      if (credential.user != null) {
        print('DEBUG REPO: Fetching user data via getUserData...');
        return await getUserData(credential.user!.uid);
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      print('DEBUG REPO: Calling createUserWithEmailAndPassword...');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('DEBUG REPO: createUserWithEmailAndPassword returned. User: ${credential.user?.uid}');

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);

        // Create user document in Firestore
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
          role: 'user',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        print('DEBUG REPO: Setting user doc in Firestore...');
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toJson());
        print('DEBUG REPO: User doc created.');

        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في التسجيل: ${e.toString()}');
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists in Firestore
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Create new user document
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            displayName: userCredential.user!.displayName ?? 'مستخدم',
            photoURL: userCredential.user!.photoURL,
            role: 'user',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toJson());

          return userModel;
        } else {
          return UserModel.fromJson(userDoc.data()!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('خطأ في تسجيل الدخول بـ Google: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('خطأ في تسجيل الخروج: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      print('DEBUG REPO: getUserData called for $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      print('DEBUG REPO: Firestore doc retrieved. Exists: ${doc.exists}');
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('DEBUG: Error getting user data: $e');
      // Return null instead of throwing to allow debugging
      return null;
      // throw Exception('خطأ في جلب بيانات المستخدم: ${e.toString()}');
    }
  }

  // Create user document
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
    } catch (e) {
      throw Exception('خطأ في إنشاء ملف المستخدم: ${e.toString()}');
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      throw Exception('خطأ في تحديث البيانات: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('خطأ في إعادة تعيين كلمة المرور: ${e.toString()}');
    }
  }
}
