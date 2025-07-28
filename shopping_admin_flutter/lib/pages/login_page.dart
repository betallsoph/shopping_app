import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_state.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Consumer<AuthState>(
        builder: (context, authState, child) {
          return Center(
            child: ElevatedButton(
              onPressed: authState.isLoading 
                  ? null 
                  : () async {
                      await authState.signInWithGoogle();
                      if (authState.isLoggedIn && onLoginSuccess != null) {
                        onLoginSuccess!();
                      }
                    },
              child: authState.isLoading 
                  ? CircularProgressIndicator()
                  : Text("Đăng nhập với Google"),
            ),
          );
        },
      ),
    );
  }
}