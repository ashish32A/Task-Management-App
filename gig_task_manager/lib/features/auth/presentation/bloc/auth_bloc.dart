import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/user_entity.dart';
import '../../domain/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final RegisterUseCase registerUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.registerUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<AuthSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInUseCase(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await registerUseCase(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthError('Registration failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignOutRequested>((event, emit) async {
      await signOutUseCase();
      emit(AuthInitial());
    });
  }
}