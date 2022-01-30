import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key, required this.errorLog}) : super(key: key);
  final String errorLog;

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  final tcolor = Color(int.parse(dotenv.get('tcolor')));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tcolor,
        title: Text('Error'),
      ),
      body: Center(
        child: Text('ERROR Route : ' + widget.errorLog),
      ),
    );
  }
}
