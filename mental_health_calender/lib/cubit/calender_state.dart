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

  GoogleAuthenticated({
    @required this.googleCredential,
    @required this.firebaseCredential,
  });
}

class GoogleCalenderLoading extends GoogleAuthenticated {}

class GoogleCalenderLoaded extends GoogleAuthenticated {
  // TODO: Calender Data
}
