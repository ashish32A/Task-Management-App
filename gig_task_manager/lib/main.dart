import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/domain/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = FirebaseAuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            signInUseCase: SignInUseCase(authRepository),
            registerUseCase: RegisterUseCase(authRepository),
            signOutUseCase: SignOutUseCase(authRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Gig Task Manager',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.generateRoute,
        home: const LoginPage(),
      ),
    );
  }
}
