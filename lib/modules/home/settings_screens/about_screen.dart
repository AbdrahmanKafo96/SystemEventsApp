import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}
class _AboutState extends State<About>  {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text("حول التطبيق"),),
        body: Container(
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: ContactUs(
              logo: AssetImage('assets/images/programmerlogo.png'),
              email: 'abdrahmankafo@gmail.com',
              companyName: '',
              githubUserName: 'AbdrahmanKafo96',
              linkedinURL: 'https://www.linkedin.com/in/abdrahman-kafo-945b331b5/',
              tagLine: 'معلومات فريق التطوير',
              twitterHandle: ' ',
              textColor: Colors.black,
              cardColor: Colors.white,
              companyColor: Colors.black,
              taglineColor: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
