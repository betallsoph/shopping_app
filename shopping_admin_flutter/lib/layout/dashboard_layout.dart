import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';
import '../services/auth_service.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(
      builder: (context, authState, _) {
        return Scaffold(
          appBar: AppBar(title: Text("Shopping Admin")),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: authState.user != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (AuthService.getUserPhotoURL() != null)
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(AuthService.getUserPhotoURL()!),
                              )
                            else
                              const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 40),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              AuthService.getUserDisplayName() ?? 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AuthService.getUserEmail() ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                ),
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text("Dashboard"),
                  onTap: () => context.go('/'),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text("Products"),
                  onTap: () => context.go('/products'),
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () {
                    context.read<AuthState>().signOut();
                  },
                ),
              ],
            ),
          ),
          body: child,
        );
      },
    );
  }
}