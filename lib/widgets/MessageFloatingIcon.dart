import 'package:flutter/material.dart';

class ChatFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChatFloatingActionButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.orange, // Match the theme color
      child: Icon(Icons.chat, color: Colors.white), // Icon for the FAB
    );
  }
}
