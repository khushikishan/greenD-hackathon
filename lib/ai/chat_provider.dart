import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greend/ai/product_provider.dart';
import 'message.dart';

class ChatProvider with ChangeNotifier {
  final GenerativeModel generativeModel;
  final ProductProvider productProvider; // Add ProductProvider
  List<Message> messages = []; // Chat history
  Map<String, String> memory = {}; // Memory for facts

  ChatProvider(this.generativeModel, this.productProvider) {
    _loadMessages();
    _loadMemory();
  }

  // Save messages to SharedPreferences
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages.map((message) => message.toJson()).toList();
    await prefs.setString('chat_messages', jsonEncode(messagesJson));
  }

  
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString('chat_messages');
    if (messagesJson != null) {
      final List<dynamic> decodedMessages = jsonDecode(messagesJson);
      messages = decodedMessages.map((json) => Message.fromJson(json)).toList();
      notifyListeners();
    }
  }


  Future<void> _saveMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_memory', jsonEncode(memory));
  }


  Future<void> _loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final memoryJson = prefs.getString('chat_memory');
    if (memoryJson != null) {
      memory = Map<String, String>.from(jsonDecode(memoryJson));
    }
  }


  void addMessage(Message message) {
    messages.add(message);
    _saveMessages();
    notifyListeners();
  }


  void _extractAndStoreFacts(String userMessage) {
    final nameMatch = RegExp(r"my name is (\w+)", caseSensitive: false).firstMatch(userMessage);
    if (nameMatch != null) {
      memory["name"] = nameMatch.group(1)!;
      _saveMemory();
    }
  }

  
  String _respondToProductQuery(String userMessage) {
    if (userMessage.toLowerCase().contains("cheapest product")) {
      final cheapestProduct = productProvider.products.reduce((a, b) => a.price < b.price ? a : b);
      return "The cheapest product is ${cheapestProduct.name} at \$${cheapestProduct.price}.";
    }
    return "";
  }

  
  Future<void> sendMessage(String userMessage) async {
    try {
      final userMessageObj = Message(role: 'user', content: userMessage);
      addMessage(userMessageObj);

     
      _extractAndStoreFacts(userMessage);

    
      final productResponse = _respondToProductQuery(userMessage);
      if (productResponse.isNotEmpty) {
        final aiMessage = Message(role: 'assistant', content: productResponse);
        addMessage(aiMessage);
        return;
      }

      
      final conversationHistory = messages
          .map((msg) => Content.text("${msg.role}: ${msg.content}"))
          .toList();
      final response = await generativeModel.generateContent(conversationHistory);

      final aiMessage = Message(
        role: 'assistant',
        content: response.text ?? "I don’t have an answer for that right now.",
      );
      addMessage(aiMessage);
    } catch (e) {
      addMessage(Message(
        role: 'assistant',
        content: "Something went wrong. Please try again.",
      ));
    }
  }
}
