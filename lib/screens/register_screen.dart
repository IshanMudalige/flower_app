import 'dart:async';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flower_app/screens/login_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatefulWidget{
  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen>{

  FirebaseAuth auth;

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  bool _isHidden = true;
  bool _validate = false;

  bool loading = false;

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() => {
      auth = FirebaseAuth.instance
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPink2,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top:80,right: 24.0, left: 24.0,bottom: 80 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    child: Text("Let's Sign Up!", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold,)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:40),
                    child: Text("Start discovering flowers.\nLet's learn together!",style: TextStyle(fontSize: 16,)),
                  ),
                ],
              ),
              Column(
                children: [
                  buildTextField("Name",nameController),
                  SizedBox(height: 20.0,),
                  buildTextField("Email",emailController),
                  SizedBox(height: 20.0,),
                  buildTextField("Password",pwdController),
                  SizedBox(height: 10.0,),

                  SizedBox(height: 30.0,),
                  buildButtonContainer(),
                  Container(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Already have an account?"),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("Login",
                            style: TextStyle(
                              color: darkGreen //Theme.of(context).primaryColor,
                            ),),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Text('Or sign up via social media'),
                    SizedBox(height: 16,),
                    Row(children:[
                      FacebookAuthButton(
                        onPressed: () {},
                        darkMode: false,
                        style: AuthButtonStyle(
                            width: 40,
                            height: 40,
                            iconSize: 25,
                            buttonType: AuthButtonType.icon,
                            borderRadius: 50
                        ),
                      ),
                      SizedBox(width: 20,),
                      TwitterAuthButton(
                        onPressed: () {},
                        darkMode: false,
                        style: AuthButtonStyle(
                            width: 40,
                            height: 40,
                            iconSize: 25,
                            buttonType: AuthButtonType.icon,
                            borderRadius: 50
                        ),
                      ),
                      SizedBox(width: 20,),
                      GoogleAuthButton(
                        onPressed: () {},
                        darkMode: false,
                        style: AuthButtonStyle(
                            width: 40,
                            height: 40,
                            iconSize: 25,
                            buttonType: AuthButtonType.icon,
                            borderRadius: 50
                        ),
                      ),
                    ])
                  ],)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText,TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
        focusColor: lightPink,
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        //   borderSide: const BorderSide(color: lightPink,),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: hintText == "Email" ? Icon(Icons.email) : hintText=="Password" ? Icon(Icons.lock) : Icon(Icons.account_circle),
        suffixIcon: hintText == "Password"
            ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget buildButtonContainer() {
    return Container(
      height: 50.0,
      child:ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: darkGreen,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: darkGreen)),
        ),
        onPressed: (){

            if(emailController.text.isEmpty || nameController.text.isEmpty || pwdController.text.isEmpty)
              setState(() {
                _validate = true;
              });
            else {
              setState(() {
                _validate = false;
                loading = true;
              });
              registerUser(
                  emailController.text, pwdController.text, nameController.text)
                  .whenComplete(() {
                  setState(() {
                    loading = false;
                  });
              });
            }
        },
        child: Center(
          child: loading ? CircularProgressIndicator() : Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),);
  }

  //user registration with firebase auth
  Future registerUser(String email,String pwd,String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pwd
      );

      await userCredential.user.updateDisplayName(name);
      _showSnack(context, 'Registered Successfully');
      Timer(Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _showSnack(context,'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _showSnack(context,'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  _showSnack(context,text) {
    final snackBar = SnackBar(
      backgroundColor: lightPink2,
      content: Text(text,style: TextStyle(color: Colors.black),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}