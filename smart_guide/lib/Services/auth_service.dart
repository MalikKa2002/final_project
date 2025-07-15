import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    //bagin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // obaiin auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final creatential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //finally , lets sign in
    return await FirebaseAuth.instance.signInWithCredential(creatential);
  }
}
