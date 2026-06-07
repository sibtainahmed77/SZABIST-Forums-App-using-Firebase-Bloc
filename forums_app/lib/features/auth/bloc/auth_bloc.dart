import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_services/firebase_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onSignIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final cred = await _authService.signIn(
      email: event.email,
      password: event.password,
    );
    final user = cred.user;
    print('USER: $user');
    print('USER UID: ${user?.uid}');
    print('USER EMAIL: ${user?.email}');
    
    if (user == null) {
      emit(AuthError(message: 'Login failed. Please try again.'));
      return;
    }
    emit(AuthAuthenticated(
      userId: user.uid,
      email: user.email ?? event.email,
    ));
  } catch (e) {
    print('SIGNIN ERROR: $e');
    emit(AuthError(message: _friendlyError(e.toString())));
  }
}
  Future<void> _onSignUp(AuthSignUpRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final cred = await _authService.signUp(
      email: event.email,
      password: event.password,
    );
    emit(AuthAuthenticated(
      userId: cred.user!.uid,
      email: cred.user!.email!,
    ));
  } catch (e) {
    print('SIGNUP ERROR: $e'); 
    emit(AuthError(message: _friendlyError(e.toString())));
  }
}
  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(AuthUnauthenticated());
  }

  String _friendlyError(String error) {
    if (error.contains('user-not-found')) return 'No account found with this email.';
    if (error.contains('wrong-password')) return 'Incorrect password.';
    if (error.contains('email-already-in-use')) return 'Email already registered.';
    if (error.contains('weak-password')) return 'Password too weak (min 6 chars).';
    return 'Something went wrong. Please try again.';
  }
}