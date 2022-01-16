import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../color.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("About Us"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AutoSizeText(
                        "DO IT",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32, color: kPrimaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ),
                const AutoSizeText("DO IT is a product of Revgrand Systems which tries to simplify the user's daily routine."
                  ,textAlign: TextAlign.justify, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
