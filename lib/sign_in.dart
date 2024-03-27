import 'package:chat_app/chat.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class SignIn extends StatefulWidget {
    SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
    bool showSpinner=false;

final _auth=FirebaseAuth.instance;

late String email;

late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true  ,

      body: ModalProgressHUD(
inAsyncCall: showSpinner,

        child: SingleChildScrollView(
          child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.all(70.0),
                  child: Image.asset("assets/images/chat.png",scale: 4),
                ),
                Text("Sign In",style: TextStyle(fontSize:25),),
                SizedBox(height: 50,),
                TextField(
        onChanged: (value){
          email=value;
        },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15)) ,
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(15))


                      ,)
                ),
                SizedBox(height: 40,),
                TextField(
        onChanged: (value){
          password=value;
        },
                    textAlign: TextAlign.center,obscureText: true,
                    decoration: InputDecoration(
                      hintText: "password",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15)) ,
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(15))


                      ,)
                ),
                SizedBox(height: 30,),
                MyButton(text: "Sign in", color: Colors.blue,function: ()async{
               setState(() {
                 showSpinner=true;
               });
                  try{
                  final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if(user!=null){
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (con){return Chat();})

                    );
                    setState(() {
                      showSpinner=true;
                    });
                  }

                }catch(e){print(e);}
                },),
                TextButton(onPressed: () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
  return SignUp();
}));
                }, child: Text("registrate",style: TextStyle(color: Colors.blue),))
              ]),
        ),
      ),
    );
  }
}
