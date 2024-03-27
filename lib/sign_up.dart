import 'package:chat_app/chat.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class SignUp extends StatefulWidget {
     SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showSpinner=false;
  final _auth =FirebaseAuth.instance;
late String email;

late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
            
                child: Column(
            
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(70.0),
                    child: Image.asset("assets/images/chat.png",scale: 4),
                  ),
                    Text("Sign Up",style: TextStyle(fontSize:25),),
                    SizedBox(height: 50,),
                  TextField(
            
                                  onChanged: (value){
                                    email=value;
                                  },
                                  textAlign: TextAlign.center,keyboardType: TextInputType.emailAddress,
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
                                  },obscureText: true,
                                  textAlign: TextAlign.center,
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
                    MyButton(text: "register", color: Colors.blue,function: ()async{
                      setState(() {
                        showSpinner=true;
                      });
                      try {
            
                    final newUser=  await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                      return Chat();
                    }), (route) => false);
                    setState(() {
                      showSpinner=false;
                    });
            
                      }catch(e){
                        print(e);
                      }
            
            
            
                    }),
                    TextButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return SignIn();
                      }));
            
                    }, child: Text("sign in",style: TextStyle(color: Colors.blue),))
                ]),
            
            ),
          ),

      ),
    );
  }
}
