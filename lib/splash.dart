import 'package:chat_app/components/button.dart';
import 'package:chat_app/sign_in.dart';
import 'package:chat_app/sign_up.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Column(
        children: [

        Padding(
          padding: const EdgeInsets.only(top: 180.0),
          child: Center(child: Image.asset("assets/images/chat.png",scale: 4)),
        ),
          SizedBox(
            height: 30,
          ),
          MyButton(text: "Sign In", color: Colors.blue,function: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return SignIn();
          }));}),
          MyButton(text: "Sign up", color: Colors.red,function: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return SignUp();
            }));
          })


      ],),
    );
  }
}
