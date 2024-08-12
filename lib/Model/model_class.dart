
import 'dart:convert';

Chats chatBotFromJson(String str) => Chats.fromJson(json.decode(str));

String chatBotToJson(Chats data) => json.encode(data.toJson());

class Chats {
  final List<String>? prompt;
  final List<String>? question;

  Chats({
     this.question,
     this.prompt,

  });

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
    // prompt: json["prompt"],
    question: json["question"] == null ? [] : List<String>.from(json["question"]!.map((x) => x)),
    prompt: json["prompt"] == null ? [] : List<String>.from(json["prompt"]!.map((x) => x)),

  );

  Map<String, dynamic> toJson() => {
    // "prompt": prompt,
    "question": question == null ? [] : List<dynamic>.from(question!.map((x) => x)),
    "prompt": prompt == null ? [] : List<dynamic>.from(prompt!.map((x) => x)),
  };


}
