
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../background.dart';
import '../color.dart';
import 'homepage.dart';

class VerificationPage extends StatefulWidget {

  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final auth = FirebaseAuth.instance;
  late Timer timer;
  late User user;

  sendEmail() {
    user = auth.currentUser!;
    auth.currentUser?.sendEmailVerification().then((value) {
      timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        checkEmailVerified();
      });
    }).catchError((e){
      _errorCheck(e);
    });
  }

  _errorCheck(e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Account exists with different credentials!")));
        break;
      case 'email-already-in-use':

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text("Email Already Exists!")));
        Navigator.of(context).pop();
        break;
      case 'network-request-failed':

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text("Internet Down, Check Your Connection")));
        break;

      default:

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
    sendEmail();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    if(timer.isActive){
      setState(() {
        timer.cancel();
      });

    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: size.height * 0.03
              ),

              SvgPicture.asset(
                "assets/images/signup.svg",
                height: size.height * 0.28,
              ),
              SizedBox(height: size.height*0.015),
              Center(
                child:RichText(
                  text: TextSpan(
                    text: 'Email sent to: ',
                    style:  const TextStyle(color: kPrimaryColor),
                    children: <TextSpan>[
                      TextSpan(text: "${user.email}",
                          style: const TextStyle(
                              color: kPrimaryColor, fontWeight: FontWeight.bold)),

                    ],
                  ),
                ),
                // Text("An email has been sent to ${user.email}", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w200),),
              ),
              Container(
                padding: EdgeInsets.only(top: size.height*0.015),
                child:  const Center(
                  child: AutoSizeText("Please Verify to use all features.",style: TextStyle(color: kPrimaryColor),),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
