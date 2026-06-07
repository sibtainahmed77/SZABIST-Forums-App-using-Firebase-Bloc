import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_services/firebase_services.dart';
import 'firebase_options.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/view/login_page.dart';
import 'features/topics/bloc/topics_bloc.dart';
import 'features/topics/view/topics_page.dart';
import 'features/replies/bloc/replies_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ForumsApp());
}

class ForumsApp extends StatelessWidget {
  const ForumsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthService()),
        RepositoryProvider(create: (_) => ForumService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthBloc(authService: ctx.read<AuthService>()),
          ),
          BlocProvider(
            create: (ctx) => TopicsBloc(forumService: ctx.read<ForumService>()),
          ),
          BlocProvider(
            create: (ctx) => RepliesBloc(forumService: ctx.read<ForumService>()),
          ),
        ],
        child: MaterialApp(
          title: 'FAST NUCES Forums',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

// Decides whether to show Login or Forums based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('AUTH STATE: $state');  
        if (state is AuthAuthenticated) return const TopicsPage();
        return const LoginPage();
      },
    );
  }
}