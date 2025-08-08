import '../data/auth_repository.dart';
import 'user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);
  Future<UserEntity?> call(String email, String password) => repository.signIn(email, password);
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  Future<UserEntity?> call(String email, String password) => repository.register(email, password);
}

class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase(this.repository);
  Future<void> call() => repository.signOut();
}