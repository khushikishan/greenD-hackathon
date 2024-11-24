class Message {
  final String role; 
  final String content;

  Message({required this.role, required this.content});

  //(JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  //(JSON deserialization)
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }
}
