import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:firebase_services/firebase_services.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
import 'auth_service_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService authService;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthService(auth: mockFirebaseAuth);
  });

  group('AuthService', () {
    test('signIn calls FirebaseAuth with correct email and password', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: '123456',
      )).thenAnswer((_) async => MockUserCredential());

      await authService.signIn(email: 'test@test.com', password: '123456');

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: '123456',
      )).called(1);
    });

    test('signUp calls FirebaseAuth with correct email and password', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'new@test.com',
        password: 'password123',
      )).thenAnswer((_) async => MockUserCredential());

      await authService.signUp(email: 'new@test.com', password: 'password123');

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'new@test.com',
        password: 'password123',
      )).called(1);
    });

    test('signOut calls FirebaseAuth signOut', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      await authService.signOut();
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}