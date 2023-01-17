part of 'cubit.dart';

class PhoneAuthDataProvider {
  String id;
  PhoneAuthDataProvider({this.id = ''}) : super();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> authenticatePhone(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {}
        },
        codeSent: (String verificationId, int? resendToken) async {
          if (verificationId.isNotEmpty) {
            id = verificationId;
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //for verifying code and signing In user
  Future<bool> authenticateOTP(String otp) async {
    bool isAuthenticated = false;
    try {
      AuthCredential credential =
          PhoneAuthProvider.credential(verificationId: id, smsCode: otp);
      await auth
          .signInWithCredential(credential)
          .then((value) {})
          .whenComplete(() {
        isAuthenticated = true;
      }).onError((error, stackTrace) {
        isAuthenticated = false;
      });
    } catch (_) {
      isAuthenticated = false;
    }
    return isAuthenticated;
  }

  Future<void> signout() async {
    await auth.signOut();
  }
}
