// lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:smart_guide/components/chat_composer.dart';
import 'package:smart_guide/components/chat_bubble.dart';
import 'package:smart_guide/services/gpt4o_mini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isAwaitingAI = false;

  void _sendMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.add({'text': trimmed, 'isUser': true});
      _isAwaitingAI = true;
    });
    _controller.clear();

    Gpt4oMiniService.getChatResponse(trimmed).then((aiReply) {
      setState(() {
        _messages.add({'text': aiReply, 'isUser': false});
        _isAwaitingAI = false;
      });
    }).catchError((err) {
      setState(() {
        _messages.add({
          'text': 'Error fetching AI response: ${err.toString()}',
          'isUser': false
        });
        _isAwaitingAI = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/Chatbot.png'),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AI Assistant',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length + (_isAwaitingAI ? 1 : 0),
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  if (_isAwaitingAI && index == 0) {
                    return const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        child: Text(
                          'AI is typing...',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  final messageIndex =
                      index - (_isAwaitingAI ? 1 : 0);
                  final message =
                      _messages[_messages.length - 1 - messageIndex];
                  return ChatBubble(
                    text: message['text'] as String,
                    isUser: message['isUser'] as bool,
                  );
                },
              ),
            ),
          ),
          ChatComposer(
            controller: _controller,
            onSend: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}
