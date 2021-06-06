import 'package:auth_buttons/auth_buttons.dart';
import 'package:flower_app/screens/main_screen.dart';
import 'package:flower_app/screens/register_screen.dart';
import 'package:flower_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{

  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  bool _isHidden = true;
  bool _validate = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => {
      FirebaseAuth.instance
          .authStateChanges()
          .listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => (MainScreen()),),);
        }
      })
    });
  }

  Future _login(String email,String pwd) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pwd
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _showSnack(context,'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _showSnack(context,'Wrong password provided for that user.');
      }
    }
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
                    child: Text("Let's Sign In!", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:40),
                    child: Text("Welcome back to Flower App.\nLet's discover together!",style: TextStyle(fontSize: 16),),
                  ),
                ],
              ),
              Column(
                children: [
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
                          Text("Don't have an account?"),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RegisterScreen(),),);
                          }, child: Text("Register",
                            style: TextStyle(
                              color: darkGreen,
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
                    Text('Or login via social media'),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: hintText == "Email"
            ? Icon(Icons.email)
            : Icon(Icons.lock),
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
              side: BorderSide(color:darkGreen)),
        ),
        onPressed: (){
          if(emailController.text.isEmpty || pwdController.text.isEmpty)
            setState(() {
              _validate = true;
            });
          else {
            setState(() {
              _validate = false;
              loading = true;
            });
            _login(
                emailController.text, pwdController.text)
                .whenComplete(() {
              setState(() {
                loading = false;
              });
            });
          }



        },
        child: Center(
          child: loading ? CircularProgressIndicator() : Text(
            "Sign In",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),);
  }

  _showSnack(context,text) {
    final snackBar = SnackBar(
      backgroundColor: lightPink2,
      content: Text(text,style: TextStyle(color: Colors.black),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}