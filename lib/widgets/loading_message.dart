import 'package:flutter/material.dart';

class LoadingMessage extends StatefulWidget {
  @override
  _LoadingMessageState createState() => _LoadingMessageState();
}

class _LoadingMessageState extends State<LoadingMessage> {
  int _currentMessageIndex = 0;
  final List<String> _messages = [
    'Nous téléchargeons les données…',
    'C’est presque fini…',
    'Plus que quelques secondes avant d’avoir le résultat…',
  ];

  @override
  void initState() {
    super.initState();
    _cycleMessages();
  }

  void _cycleMessages() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
      });
      _cycleMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _messages[_currentMessageIndex],
      style: TextStyle(
        fontSize: 18,
        color: Colors.grey[700],
      ),
    );
  }
}
