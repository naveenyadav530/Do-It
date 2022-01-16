import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doit/ui/login.dart';
import 'package:doit/ui/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/users.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool progress = false;
  String name = "";
  String email = "";
  String password = "";
  final usersRef = FirebaseFirestore.instance.collection('users').withConverter<Users>(
    fromFirestore: (snapshot, _) => Users.fromJson(snapshot.data()!),
    toFirestore: (Users, _) => Users.toJson(),
  );

  _signUp() async {
    try {
      setState(() => progress = true);
      final User? user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
      )).user;
      if(user!=null){
        usersRef.doc(auth.currentUser?.uid).set(
          Users(userId: auth.currentUser?.uid, full_name: name, email_address: auth.currentUser?.email, password: password)
        ).then((value){
          List todos = ['Welcome to Do It', "Create your first Do It"];
          FirebaseFirestore.instance.collection("users").doc(user.uid).collection("do_it").doc("todo").set({
            "doit":FieldValue.arrayUnion(todos)
          }).then((value) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text("Sign Up Successfull.")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const VerificationPage()));
          }).catchError((error) {
            _errorCheck(error);
          });

        }).catchError((error) {
          _errorCheck(error);
        });
      }
      else {
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text("Sign UP Failed")));
      }

    } on FirebaseAuthException catch (e) {
    _errorCheck(e);
    }
  }

  _errorCheck(e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Account exists with different credentials!")));
        break;
      case 'email-already-in-use':
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text("Email Already Exists!")));
        Navigator.of(context).pop();
        break;
      case 'network-request-failed':
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Internet Down, Check Your Connection")));
        break;

      default:
        setState(() => progress = false);
        if (kDebugMode) {
          print(e.code);
        }
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Technical Error, Please try again.")));
        break;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/sign_up.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: size.width*0.08, top: size.height*0.08),
              child: AutoSizeText(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size.width*0.05,),
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Name",

                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                )),
                            onChanged: (String value){
                              name = value;
                            },
                            textCapitalization: TextCapitalization.words,
                          ),
                          SizedBox(
                            height: size.height*0.03,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                )),
                            onChanged: (String value){
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: size.width*0.04,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                )),
                            onChanged: (String value){
                              password  = value;
                            },
                          ),
                          SizedBox(
                            height: size.width*0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: size.width*0.08,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if(name!=""){
                                        if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
                                          if(password!=""){
                                            _signUp();
                                          }else{
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(
                                                  const SnackBar(content: Text("Password Required!")));
                                          }
                                        }else{
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                                const SnackBar(content: Text("Invalid Email Address!")));
                                        }
                                      }
                                      else{
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                              const SnackBar(content: Text("Enter Your Full Name!")));
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height*0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LogIn()));
                                },
                                child: AutoSizeText(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height*0.02,
                          ),
                          progress?CircularProgressIndicator(color: Colors.red,):Container(),

                        ],
                      ),
                    ),
                    ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}