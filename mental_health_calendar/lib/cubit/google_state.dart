part of 'google_cubit.dart';

@immutable
abstract class GoogleState {}

class GoogleLoading extends GoogleState {}

class GoogleUnauthenticated extends GoogleState {}

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

class GoogleCalendarLoading extends GoogleAuthenticated {
  GoogleCalendarLoading(GoogleAuthenticated auth) : super.copy(auth);
}

class GoogleCalendarLoaded extends GoogleAuthenticated {
  final List<Event> events;

  GoogleCalendarLoaded(
    GoogleAuthenticated auth, {
    @required this.events,
  }) : super.copy(auth);
}
