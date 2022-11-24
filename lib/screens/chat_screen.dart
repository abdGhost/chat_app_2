import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final _auth = FirebaseAuth.instance;

  final messageTextController = TextEditingController();

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessageStream() async {
  //   await for (var snapshots in firestore.collection('messages').snapshots()) {
  //     for (var message in snapshots.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      firestore.collection('messages').add({
                        'sender': loggedInUser!.email,
                        'text': messageText,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: firestore.collection('messages').snapshots(),
      stream: firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          );
        }

        final messages = snapshot.data?.docs.reversed;
        List<MessageBubbles> messageBubbles = [];

        for (var message in messages!) {
          final messageData = message.data();
          final messageText = messageData['text'];
          final messageSender = messageData['sender'];

          final currentUser = loggedInUser!.email;
          final messageBubble = MessageBubbles(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          final messageWidgets = messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: ListView(
              reverse: true,
              children: messageBubbles,
            ),
          ),
        );
      },
    );
  }
}

class MessageBubbles extends StatelessWidget {
  MessageBubbles({
    this.text,
    this.sender,
    this.isMe,
  });
  final String? text;
  final String? sender;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender!,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
          Material(
            elevation: 5,
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            borderRadius: isMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe! ? Colors.white : Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
