import 'package:flutter/material.dart';
import 'package:flutter_fire_chat/model/message.dart';
import 'package:flutter_fire_chat/model/user.dart';
import 'package:flutter_fire_chat/res/db_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final User current;
  final User selected;

  const ChatPage({Key key, this.current, this.selected}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String chatId;
  String text;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.current.id.hashCode <= widget.selected.id.hashCode) {
      chatId =
          (widget.current.id.hashCode + widget.selected.id.hashCode).toString();
    } else {
      chatId =
          (widget.selected.id.hashCode + widget.current.id.hashCode).toString();
    }
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selected.name != null
            ? widget.selected.name
            : widget.selected.email),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamProvider.value(
              value: DatabaseService().streamMessages(chatId),
              child: Consumer(
                builder: (context, List<Message> messages, _) {
                  if(messages == null || messages.length == 0) return Container();
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10.0);
                    },
                    reverse: true,
                    itemCount: messages?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message m = messages[index];
                      if (m.userId == widget.current.id)
                        return _buildMessageRow(m, current: true);
                      return _buildMessageRow(m, current: false);
                    },
                  );
                },
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Aa"),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    await DatabaseService().createMessage(
        chatId,
        Message(
            description: _controller.text,
            timestamp: DateTime.now(),
            userId: widget.current.id));
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _controller.clear();
    });
  }

  Row _buildMessageRow(Message m, {bool current}) {
    User user;
    if (current)
      user = widget.current;
    else
      user = widget.selected;
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        if (!current) ...[
          CircleAvatar(
            backgroundImage:
                user.avatar != null ? NetworkImage(user.avatar) : null,
            radius: 20.0,
            child: user.avatar == null
                ? Text(user.name != null ? user.name[0] : user.email[0])
                : null,
          ),
          const SizedBox(width: 5.0),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
              color: current ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            m.description,
            style: TextStyle(
                color: current ? Colors.white : Colors.black, fontSize: 18.0),
          ),
        ),
        if (current) ...[
          const SizedBox(width: 5.0),
          CircleAvatar(
            backgroundImage:
                user.avatar != null ? NetworkImage(user.avatar) : null,
            radius: 10.0,
            child: user.avatar == null
                ? Text(user.name != null ? user.name[0] : user.email[0])
                : null,
          ),
        ],
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}
