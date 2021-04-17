import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import "package:http/http.dart";
import 'package:meta/meta.dart';

part 'google_state.dart';

class _AuthClient extends BaseClient {
  final _client = Client();
  final Map<String, String> Function() getAuthHeaders;

  _AuthClient(this.getAuthHeaders);

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(getAuthHeaders());
    return _client.send(request);
  }

  @override
  void close() {}
}

class GoogleCubit extends Cubit<GoogleState> {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  final googleSignIn =
      GoogleSignIn(scopes: [CalendarApi.calendarReadonlyScope]);

  Map<String, String> _headers;
  _AuthClient _client;
  CalendarApi _calendarApi;

  GoogleCubit() : super(GoogleUnauthenticated()) {
    _client = _AuthClient(() => _headers);
    _calendarApi = CalendarApi(_client);
    login();
  }

  Future<void> login() async {
    if (state is GoogleUnauthenticated) {
      emit(GoogleLoading());

      try {
        await _firebaseInitialization;

        GoogleSignInAccount googleUser = await googleSignIn.signInSilently();

        if (googleUser == null) {
          googleUser = await googleSignIn.signIn();
        }

        if (googleUser == null) {
          emit(GoogleUnauthenticated());
          return;
        }

        _headers = await googleUser.authHeaders;

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
          googleUser: googleUser,
          googleCredential: googleCredential,
          firebaseCredential: firebaseCredential,
        ));

        loadCalendar();
      } catch (e) {
        googleSignIn.signOut();
        FirebaseAuth.instance.signOut();
        emit(GoogleUnauthenticated(error: e));
      }
    }
  }

  Future<void> loadCalendar() async {
    if (state is GoogleAuthenticated && !(state is GoogleCalendarLoading)) {
      GoogleAuthenticated _state = state;
      try {
        emit(GoogleCalendarLoading(_state));

        final calendars = await _calendarApi.calendarList.list();

        final now = DateTime.now();
        final todayStart = now
            .subtract(Duration(
              hours: now.hour,
              minutes: now.minute,
              seconds: now.second,
              milliseconds: now.millisecond,
              microseconds: now.microsecond,
            ))
            .toUtc();
        final todayEnd = todayStart.add(Duration(days: 1));

        final eventLists = await Future.wait(calendars.items.map(
          (calendar) => _calendarApi.events.list(
            calendar.id,
            timeMin: todayStart,
            timeMax: todayEnd,
            singleEvents: true,
          ),
        ));
        final events =
            eventLists.expand((eventList) => eventList.items).toList();

        emit(GoogleCalendarLoaded(
          _state,
          todayStart: todayStart,
          todayEnd: todayEnd,
          events: events,
        ));
      } catch (e) {
        print(e);
        emit(GoogleAuthenticated.copy(_state));
      }
    }
  }
}
