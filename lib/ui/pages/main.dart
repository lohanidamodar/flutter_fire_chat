import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/ui/pages/home.dart';
import '../../model/user_repository.dart';
import 'package:provider/provider.dart';
import './splash.dart';
import './login.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return HomePage();
          }
        },
      ),
    );
  }
}