import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String body;
  final String creationDate;
  final bool sentByUser; // Indicates whether the message was sent by the user
  bool read; // Indicates whether the message is read

  ChatMessage({
    required this.body,
    required this.creationDate,
    required this.sentByUser,
    required this.read,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int userId) {
    return ChatMessage(
      body: json['body'],
      creationDate: json['creationDate'],
      sentByUser: json['senderId'] == userId,
      read: json['read'] ?? false, // Default to false if read key not present
    );
  }

  String formattedCreationDate() {
    // Format DateTime object to display date in "MM/DD" format and time in "hh:mm aa" format
    DateTime dateTime = DateTime.parse(creationDate);
    String formattedDate =
        '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    String formattedTime =
        '${(dateTime.hour % 12).toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    return '$formattedDate $formattedTime';
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
  int? userId;
  int? currentConversationId;
  String appBarTitle = '';
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchMessages(int conversationId) async {
    final apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/get/message/$conversationId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        messages = responseData
            .map((json) => ChatMessage.fromJson(json, userId!))
            .toList();
      });
    } else {
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  Future<void> fetchConversations() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    final apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/findAll/conversation/$userId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        conversations =
            responseData.map((json) => Conversation.fromJson(json)).toList();
      });
    } else {
      print('Failed to load conversations: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(int conversationId, String message) async {
    final apiUrl = 'http://62.72.13.94:9081/api/ramchtmsg/send/message';
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    Map<String, dynamic> chattingData = {
      "conversation": {"id": conversationId},
      "senderId": userId,
      "creationDate": DateTime.now().toUtc().toIso8601String().substring(0, 19),
      "body": message,
      "read": false, // Mark message as unread initially
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
      print('Message sent!');
      fetchMessages(conversationId); // Refresh messages after sending
    } else {
      print('Error sending message: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
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
              for (var conversation in conversations)
                ListTile(
                  title: Text(conversation.name),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    setState(() {
                      currentConversationId = conversation.id;
                      appBarTitle = conversation.name; // Update app bar title
                    });
                    fetchMessages(conversation
                        .id); // Fetch messages for selected conversation
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: message.sentByUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: message.sentByUser
                                  ? const Color.fromARGB(255, 47, 206, 84)
                                  : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message.body,
                                    style: TextStyle(
                                        color: message.sentByUser
                                            ? Colors.white
                                            : Colors.black)),
                                Text(
                                  message.formattedCreationDate(),
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 142, 124, 232)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (message
                            .sentByUser) // Only show tick marks for messages sent by the user
                          Icon(
                            message.read
                                ? Icons.done_all
                                : Icons
                                    .done, // If message is read, display double tick, otherwise display single tick
                            color: message.read
                                ? Colors.blue
                                : Colors.blue, // Use blue color for both ticks
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 183, 164, 202),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (message) async {
                      if (currentConversationId != null) {
                        await sendMessage(currentConversationId!, message);
                        _messageController.clear();
                      }
                    },
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
                    if (currentConversationId != null) {
                      String message = _messageController.text;
                      _messageController.clear();
                      await sendMessage(currentConversationId!, message);
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





//   here some corrected code for tick mark 

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String body;
  final String creationDate;
  final bool sentByUser; // Indicates whether the message was sent by the user
  bool read; // Indicates whether the message is read

  ChatMessage({
    required this.body,
    required this.creationDate,
    required this.sentByUser,
    required this.read,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int userId) {
    return ChatMessage(
      body: json['body'],
      creationDate: json['creationDate'],
      sentByUser: json['senderId'] == userId,
      read: json['read'] ?? false, // Default to false if read key not present
    );
  }

  String formattedCreationDate() {
    // Convert creationDate string to DateTime object
    DateTime dateTime = DateTime.parse(creationDate);
    // Format DateTime object to display date in "MM/DD" format and time in "hh:mm aa" format
    String formattedDate =
        '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    String formattedTime =
        '${(dateTime.hour % 12).toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    return '$formattedDate $formattedTime';
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
  int? userId;
  int? currentConversationId;
  String appBarTitle = '';
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> messages = [];
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchMessages(int conversationId) async {
    final apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/get/message/$conversationId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        messages = responseData
            .map((json) => ChatMessage.fromJson(json, userId!))
            .toList();
      });
    } else {
      print('Failed to load messages: ${response.statusCode}');
    }
  }

  Future<void> fetchConversations() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    final apiUrl =
        'http://62.72.13.94:9081/api/ramchtmsg/findAll/conversation/$userId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        conversations =
            responseData.map((json) => Conversation.fromJson(json)).toList();
      });
    } else {
      print('Failed to load conversations: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(int conversationId, String message) async {
    final apiUrl = 'http://62.72.13.94:9081/api/ramchtmsg/send/message';
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    Map<String, dynamic> chattingData = {
      "conversation": {"id": conversationId},
      "senderId": userId,
      "creationDate": DateTime.now().toUtc().toIso8601String().substring(0, 19),
      "body": message,
      "read": false, // Mark message as unread initially
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
      print('Message sent!');
      fetchMessages(conversationId); // Refresh messages after sending
    } else {
      print('Error sending message: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
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
              for (var conversation in conversations)
                ListTile(
                  title: Text(conversation.name),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    setState(() {
                      currentConversationId = conversation.id;
                      appBarTitle = conversation.name; // Update app bar title
                    });
                    fetchMessages(conversation
                        .id); // Fetch messages for selected conversation
                  },
                ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: message.sentByUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: message.sentByUser
                                  ? const Color.fromARGB(255, 47, 206, 84)
                                  : Colors.blueGrey,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(message.body,
                                    style: TextStyle(
                                        color: message.sentByUser
                                            ? Colors.white
                                            : Colors.black)),
                                Text(
                                  message.formattedCreationDate(),
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 142, 124, 232)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (message
                            .sentByUser) // Only show tick marks for messages sent by the user
                          Icon(
                            message.read
                                ? Icons.done_all // If message is sent by user and read, display double tick
                                : Icons.done, // If message is sent by user but not read, display single tick
                            color: message.read
                                ? Colors.blue // Apply blue color for double tick
                                : null,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 183, 164, 202),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (message) async {
                      if (currentConversationId != null) {
                        await sendMessage(currentConversationId!, message);
                        _messageController.clear();
                      }
                    },
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
                    if (currentConversationId != null) {
                      String message = _messageController.text;
                      _messageController.clear();
                      await sendMessage(currentConversationId!, message);
                    }
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
