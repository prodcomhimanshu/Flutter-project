import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String body;
  final String creationDate;

  ChatMessage({
    required this.body,
    required this.creationDate,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      body: json['body'],
      creationDate: json['creationDate'],
    );
  }
}

class Conversation {
  final int id;
  final String name;

  Conversation({
    required this.id,
    required this.name,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  List<Conversation> conversations = [];
  Conversation? selectedConversation;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    fetchConversations();
  }

  Future<void> fetchMessages() async {
    final apiUrl = 'http://62.72.13.94:9081/api/ramchtmsg/get/message/83';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        messages =
            responseData.map((json) => ChatMessage.fromJson(json)).toList();
      });
    } else {
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  Future<void> fetchConversations() async {
    final apiUrl = 'http://localhost:9081/api/ramchtmsg/findAll/conversation/5';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        conversations = responseData.map((json) => Conversation.fromJson(json)).toList();
      });
    } else {
      print('Failed to load conversations: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(String message) async {
    int? userId;
    final apiUrl = 'http://62.72.13.94:9081/api/ramchtmsg/send/message';
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    Map<String, dynamic> chattingData = {
      "conversation": {"id": 77},
      "senderId": userId,
      "creationDate": DateTime.now().toUtc().toIso8601String(),
      "body": message,
      "read": false
    };

    String jsonBody = jsonEncode(chattingData);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Message sent successfully (you can handle this as needed)
      print('Message sent!');
      fetchMessages(); // Refresh messages after sending
    } else {
      // Handle error (e.g., display an error message to the user)
      print('Error sending message: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting with Your Registered Business'),
      ),
      drawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7, // Adjust the width as needed
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Conversations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              // Display conversation names as list tiles
              for (var conversation in conversations)
                ListTile(
                  title: Text(conversation.name),
                  onTap: () {
                    setState(() {
                      selectedConversation = conversation;
                    });
                    Navigator.pop(context); // Close the drawer
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (selectedConversation != null)
            Expanded(
              child: Column(
                children: [
                  Text(selectedConversation!.name),
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ListTile(
                          title: Text(message.body),
                          subtitle: Text(message.creationDate),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message here...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        FloatingActionButton(
                          onPressed: () async {
                            String message = _messageController.text;
                            _messageController.clear();
                            await sendMessage(message);
                          },
                          child: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

 
