part of 'calender_cubit.dart';

@immutable
abstract class GoogleState {}

class GoogleLoading extends GoogleState {}

class GoogleUnauthenticated extends GoogleState {
  final dynamic error;

  GoogleUnauthenticated({this.error});
}

class GoogleAuthenticated extends GoogleState {
  final GoogleAuthCredential googleCredential;
  final UserCredential firebaseCredential;
  final GoogleSignInAccount googleUser;

  GoogleAuthenticated({
    @required this.googleUser,
    @required this.googleCredential,
    @required this.firebaseCredential,
  });

  GoogleAuthenticated.copy(GoogleAuthenticated auth)
      : this(
          googleUser: auth.googleUser,
          googleCredential: auth.googleCredential,
          firebaseCredential: auth.firebaseCredential,
        );
}

class GoogleCalenderLoading extends GoogleAuthenticated {
  GoogleCalenderLoading(GoogleAuthenticated auth) : super.copy(auth);
}

class GoogleCalenderLoaded extends GoogleAuthenticated {
  // TODO: Calender Data

  GoogleCalenderLoaded(GoogleAuthenticated auth) : super.copy(auth);
}
