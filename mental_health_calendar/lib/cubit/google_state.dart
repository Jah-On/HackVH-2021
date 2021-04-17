part of 'google_cubit.dart';

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

class GoogleCalendarLoading extends GoogleAuthenticated {
  GoogleCalendarLoading(GoogleAuthenticated auth) : super.copy(auth);
}

class GoogleCalendarLoaded extends GoogleAuthenticated {
  final List<Event> events;
  final DateTime todayStart;
  final DateTime todayEnd;

  GoogleCalendarLoaded(
    GoogleAuthenticated auth, {
    @required this.events,
    @required this.todayStart,
    @required this.todayEnd,
  }) : super.copy(auth);
}
