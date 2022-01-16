import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../background.dart';
import '../color.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  FirebaseAuth auth = FirebaseAuth.instance;
  bool progress = false;
  String email = "";
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
      case 'user-not-found':
        setState(() => progress = false);
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Email does not exists, Please check your email")));
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
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/images/forget.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              const AutoSizeText("Enter your email to reset your password",
                style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                child: TextField(
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
              ),
              SizedBox(height: size.height * 0.05),
              CircleAvatar(
                radius: size.width*0.07,
                backgroundColor: const Color(0xff4c505b),
                child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)){
                        setState(() {
                          progress = true;
                        });
                        auth.sendPasswordResetEmail(email: email).then((value){
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content: Text("Email sent successfully!")));
                          Navigator.of(context).pop();

                        }).catchError((e){
                          _errorCheck(e);
                        });
                      }else{
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              content: Text("Invalid Email!")));
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                    )),
              ),
              SizedBox(
                height: size.height*0.02,
              ),
              progress?CircularProgressIndicator(color: Colors.red,):Container(),
            ],
          ),
        ),
      ),
    );
  }
}
