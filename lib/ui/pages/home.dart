import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/model/user.dart';
import 'package:flutter_fire_chat/model/user_repository.dart';
import 'package:flutter_fire_chat/res/db_provider.dart';
import 'package:flutter_fire_chat/ui/pages/chat.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: UserRepository.instance().signOut,
          )
        ],
      ),
      body: StreamProvider.value(
        value: DatabaseService().streamUsers(),
        child: Consumer(
          builder: (context, List<User> users, _) {
            return ListView.builder(
              itemCount: users?.length,
              itemBuilder: (BuildContext context, int index) {
                User user = users[index];
                bool current =
                    Provider.of<UserRepository>(context).user.uid == user.id;
                if (current) {
                  currentUser = user;
                  return Container();
                }
                return ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatPage(
                                current: currentUser,
                                selected: user,
                              ))),
                  leading: CircleAvatar(
                    backgroundImage:
                        user.avatar != null ? NetworkImage(user.avatar) : null,
                    radius: 20.0,
                    child: user.avatar == null
                        ? Text(user.name != null ? user.name[0].toUpperCase() : user.email[0].toUpperCase())
                        : null,
                  ),
                  title: Text(user.name != null ? user.name : user.email),
                  subtitle: user.name != null ? Text(user.email) : null,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
