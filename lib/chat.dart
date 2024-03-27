import 'package:chat_app/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

late User signedInUser;
final _firestore = FirebaseFirestore.instance;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  var myController = TextEditingController();

  String? sendedMessage;
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
       print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Row(
          children: [
            Image.asset(
              "assets/images/chat.png",
              scale: 18,
            ),
          const  SizedBox(
              width: 10,
            ),
           const Text(
              "MY Message",
              style: TextStyle(color: Colors.white, fontSize: 27),
            ),
          ],
        ),
        actions: [
        const  SizedBox(width: 30),
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return Splash();
                    }), (route) => false);
              },
              icon:const Icon(
                Icons.clear,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamWidget(),
            Container(
              decoration:const BoxDecoration(
                  border:
                  Border(top: BorderSide(color: Colors.orange, width: 2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child:  TextField(
                        controller: myController,
                        onChanged: (value) {
                          sendedMessage = value;
                        },
                        decoration:const InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            hintText: "Wite your message here ...",
                            border: InputBorder.none),
                      )),
                  TextButton(
                      onPressed: () {
                        myController.clear();
                        _firestore.collection("messages").add({
                          "sender": signedInUser.email,
                          "text": sendedMessage,
                          "timer": FieldValue.serverTimestamp(),
                        });
                      },
                      child:const Text(
                        "Send",
                        style:  TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StreamWidget extends StatefulWidget {
  const StreamWidget({Key? key}) : super(key: key);

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection("messages").orderBy("timer").snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            final messageText = message.get('text');
            final messagemail = message.get('sender');
            final messagetime = message.get('timer');

            final currentUser = signedInUser.email;
            final chat = MessageLine(
              sender: messagemail,
              text: messageText,
              isMe: currentUser == messagemail,
              time: messagetime,
            );

            messageWidgets.add(chat);
          }
          return Expanded(
            child: ListView(
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageLine extends StatefulWidget {
  final bool isMe;
  final String? sender;
  final String? text;
  final Timestamp? time;

  const MessageLine(
      {required this.isMe, this.text, this.sender, this.time, Key? key})
      : super(key: key);

  @override
  State<MessageLine> createState() => _MessageLineState();
}

class _MessageLineState extends State<MessageLine> {
  String formattedTime = '';

  void convertTime(Timestamp? time) {
    DateTime dateTime = time!.toDate();
    formattedTime = '${dateTime.hour}:${dateTime.minute}';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    convertTime(widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: widget.isMe == true
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(widget.sender ?? ""),
            Row(
              mainAxisAlignment: widget.isMe == true
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Material(
                  elevation: 13,
                  color: widget.isMe == true ? Colors.blue : Colors.grey[300],
                  borderRadius: widget.isMe
                      ?const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(16))
                      :const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "${widget.text}",
                          style:const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Time: $formattedTime",
                          style:const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
               const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    convertTime(widget.time);
                  },
                  child:const Text("convert"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
