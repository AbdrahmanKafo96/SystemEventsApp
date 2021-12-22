import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  String _url;
  Logo(this._url);
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
       child: Center(child: Image(
         image: AssetImage('assets/images/${widget._url}'),
         width: 200,
         height: 200,))
    );
  }
}
