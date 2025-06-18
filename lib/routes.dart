import 'package:go_router/go_router.dart';
import 'package:swapper/screens/auth_screen.dart';
import 'package:swapper/screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/publicar_articulo_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/chat_screen.dart';
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/publicar',
      builder: (context, state) => const PublicarArticuloScreen(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const PerfilScreen(),
    ),
    GoRoute(
      path: '/ChatScreen',
      builder: (context, state) => const ChatScreen(exchangeId: '',),
    ),
  ],
);