import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'calender_state.dart';

class GoogleCubit extends Cubit<GoogleState> {
  Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  GoogleCubit() : super(GoogleUnauthenticated()) {
    login();
  }

  void login() async {
    if (state is GoogleUnauthenticated) {
      emit(GoogleLoading());

      try {
        await _firebaseInitialization;

        GoogleSignInAccount googleUser = await GoogleSignIn().signInSilently();

        if (googleUser == null) {
          googleUser = await GoogleSignIn().signIn();
        }

        if (googleUser == null) {
          emit(GoogleUnauthenticated());
          return;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final GoogleAuthCredential googleCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final UserCredential firebaseCredential =
            await FirebaseAuth.instance.signInWithCredential(googleCredential);

        emit(GoogleAuthenticated(
          googleCredential: googleCredential,
          firebaseCredential: firebaseCredential,
        ));
      } catch (e) {
        emit(GoogleUnauthenticated(error: e));
      }
    }
  }

  void loadCalender() async {
    if (state is GoogleAuthenticated && !(state is GoogleCalenderLoading)) {
      GoogleAuthenticated _state = state;
    }
  }
}
