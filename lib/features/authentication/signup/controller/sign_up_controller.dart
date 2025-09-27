
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';



class SignUpController extends GetxController {
  String? userName;
  String? photo;
  String? email;


  // Future<User?> signInWithGoogle() async {
  //   try {
  //     googleSignIn.initialize(
  //       serverClientId: "183676376870-onmtpsaonl25a2ho10u0hi131jhut0fh.apps.googleusercontent.com",
  //     );

  //     final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
  //     if (googleUser == null) return null;

  //     final GoogleSignInAuthentication googleAuth = googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.idToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
  //     final user = userCredential.user;

  //     if (user != null) {
  //       await AppStorage.setUser(
  //         email: user.email ?? "",
  //         userName: user.displayName ?? "",
  //         photo: user.photoURL ?? "",
  //       );
  //     }

  //     router.go('/home_screen');
  //     AppSnackBar.show(" ✅ Sucessfully logged in", backgroundColor: AppColors.greenColor, textColor: AppColors.blackColor);
  //     return userCredential.user;
  //   } catch (e) {
  //     AppSnackBar.show(" ❌ Something Went Wrong $e", backgroundColor: AppColors.redColor);
  //     debugPrint("Google sign-in failed: $e");
  //     return null;
  //   }
  // }

  //   Future<User?> signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       final accessToken = result.accessToken!;
  //       final credential = FacebookAuthProvider.credential(accessToken.tokenString);
  //       final userCredential = await firebaseAuth.signInWithCredential(credential);
  //       return userCredential.user;
  //     } else {
  //      debugPrint(" Facebook login failed: ${result.status}");
  //       return null;
  //     }
  //   } catch (e) {
  //     debugPrint("Facebook sign-in error: $e");
  //     return null;
  //   }
  // }

  // Future<void> signOut() async {
  //   await googleSignIn.signOut();
  //   await firebaseAuth.signOut();

  //   // Clear saved data
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();

  //   // Clear controller variables
  //   email = null;
  //   userName = null;
  //   photo = null;
  // }

  // User? get currentUser => firebaseAuth.currentUser;

  // //  Helper method to get stored user details
  // Future<Map<String, String?>> getUserFromPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return {
  //     "email": prefs.getString("email"),
  //     "userName": prefs.getString("userName"),
  //     "photo": prefs.getString("photo"),
  //   };
  // }
}
