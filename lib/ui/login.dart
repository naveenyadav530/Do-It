import 'package:auto_size_text/auto_size_text.dart';
import 'package:doit/color.dart';
import 'package:doit/ui/forget_password.dart';
import 'package:doit/ui/homepage.dart';
import 'package:doit/ui/sign_up.dart';
import 'package:doit/ui/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool progress = false;
  String email = "";
  String password = "";

  validation(){
    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
      if(password!=""){
        _login();
      }else{
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text("Password Required!")));
      }
    }
    else{
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text("Invalid Email Address!")));
    }
  }
  _login() async {
    try {
      setState(()=>progress=true);
      final User? user = (await auth.signInWithEmailAndPassword(email: email,password: password,)).user;
      if (user != null) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Sign In Successfull.")));
        progress = false;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      }else{
        setState(() =>  progress=false);
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text("LOG IN Failed")));
      }
    } on FirebaseAuthException catch (e) {
      _errorCheck(e);
    }
  }

  checkAuthentication(){
    setState(() {
      progress = true;
    });
    auth.authStateChanges().listen((User? user) {
      if (user != null ) {
        if(user.emailVerified){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const VerificationPage()));
        }
      }
      else{
        setState(() {
          progress = false;
        });
      }
    }).onError((error){
      _errorCheck(error);
    });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthentication();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/login.png"), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [

            Container(
              padding: EdgeInsets.only(left: size.width*0.08, top: size.height*0.18),
              child: const AutoSizeText(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: size.height * 0.45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: size.width*0.08, right: size.width*0.08),
                      child: Column(
                        children: [
                          TextField(
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                )),
                            onChanged: (String value){
                              email = value;
                            },
                          ),
                          SizedBox(
                            height: size.height*0.03,
                          ),
                          TextField(
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(size.width*0.02),
                                )),
                            onChanged: (String value){
                              password = value;
                            },
                          ),
                          SizedBox(
                            height: size.width*0.08,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AutoSizeText(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: size.width*0.07,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                     validation();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height*0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUp()));

                                },
                                child: const AutoSizeText(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: const ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgetPassword()));
                                  },
                                  child: const AutoSizeText(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          ),
                          progress?const CircularProgressIndicator(color: dangerColor,):Container(),
                        ],
                      ),
                    )
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