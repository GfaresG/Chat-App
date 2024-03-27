import 'package:chat_app/chat.dart';
import 'package:chat_app/sign_up.dart';
import 'package:chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async{


  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(

      MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({super.key});
  // This widget is the root of your application.
    final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat app',

      home: _auth.currentUser!=null ? Chat():Splash(),
    );
  }
}
