import 'package:go_router/go_router.dart';
import '../auth_state.dart';
import '../layout/dashboard_layout.dart';
import '../pages/dashboard_page.dart';
import '../pages/products_page.dart';
import '../pages/login_page.dart';
import 'package:provider/provider.dart';

GoRouter createRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authState,
    redirect: (context, state) {
      final loggedIn = authState.isLoggedIn;
      final loggingIn = state.uri.path == '/login';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder:
            (context, state) => LoginPage(
              onLoginSuccess: () => context.read<AuthState>().login(),
            ),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardLayout(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => DashboardPage()),
          GoRoute(
            path: '/products',
            builder: (context, state) => ProductsPage(),
          ),
        ],
      ),
    ],
  );
}