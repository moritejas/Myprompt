// ignore_for_file: avoid_print, unused_import, file_names, library_private_types_in_public_api
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../main.dart';
import '../Model/model_class.dart';

class Gemini22 extends StatefulWidget {
  const Gemini22({super.key});

  @override
  _Gemini22State createState() => _Gemini22State();
}

class _Gemini22State extends State<Gemini22> {
  List<Map<String, String>> messages = [];

  void geminiApi1(String usertopic) async {
    String fristprompt =
        ''' You act as my prompt creator. Your aim is to help me create the best possible prompt for my needs. This prompt will be used in "Gemini".
      topic : "$usertopic". You have to ask me five questions related to the prompt or topic I have given and I will answer them.
       You have to ask questions that I will answer and you can read them and create three good prompts.
      You have to ask me questions one after the other like you ask me one question and after
      I have answered you have to ask another question in this way you have to ask me five questions that I can easily understand.
      Then finally you have to give me a prompt.''';
    try {
      final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKeys,
          generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              responseSchema: Schema.object(
                properties: {
                  'question': Schema.array(
                      items:
                          Schema.string(description: "topic related question")),
                },
              )));
      final prompt = Content.text(fristprompt);
      final response = await model.generateContent([prompt]);

      if (response.text != null) {
        print('${response.text}');
        final chatBot = chatBotFromJson(response.text!);

        print('$response.text');
        final questionses = chatBot.question;

        setState(() {
          messages.add({'sender': 'user', 'text': usertopic});
          if (questionses != null) {
            for (var question in questionses) {
              messages.add({'sender': 'gemini', 'text': question});
            }
            messages.add({'sender': 'gemini', 'text':
            'You answer me the above questions \n Exa:  1 : [Answer],\n  2 : [Answer],'
                '\n  3 : [Answer],\n  4 : [Answer],\n  5 : [Answer],'});

          } else {
            print("Questinses is null");
          }
        });

        print('User == $usertopic');
        print('Gemini == ${response.text}');
      } else {
        print("Response doesn't contain text.");
      }
    } catch (e) {
      // Handle API errors
      print('Error calling Gemini API: $e');
      Fluttertoast.showToast(msg: 'Error: Failed to get response');
    }
  }

  void geminiApi2(String answer) async {
    String fristprompt =
        '''The answer to the five questions he asked me above is in "$answer" 
       Now you make three prompts related to it using that.''';
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKeys,
      );
      final prompt = Content.text(fristprompt);
      final response = await model.generateContent([prompt]);

      if (response.text != null) {
        print('${response.text}');
        setState(() {
          if (response.text != null) {
            messages.add({'sender': 'gemini', 'text': 'You Topic related Prompt'});
            messages.add({'sender': 'gemini', 'text': response.text!});

            // messages.add({'sender': 'gemini', 'text': 'You give me answer'});
          }
        });
        print('User == $answer');
        print('Gemini == ${response.text}');
      } else {
        print("Response doesn't contain text.");
      }
    } catch (e) {
      // Handle API errors
      print('Error calling Gemini API: $e');
      Fluttertoast.showToast(msg: 'Error: Failed to get response');
    }
  }

  final TextEditingController _sendmessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          'Prompt Generate',
          style: TextStyle(color:Colors.white,fontSize: 30, fontWeight: FontWeight.bold),
          // style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,

      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                // reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Align(
                    alignment: message['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message['sender'] == 'gemini')
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: const Text(
                              'G',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: message['sender'] == 'user'
                                  ? Colors.blue[200]
                                  : Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Text(
                              message['text']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        if (message['sender'] == 'user')
                          CircleAvatar(
                            backgroundColor: Colors.blue[200],
                            child: const Text(
                              'U',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _sendmessageController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type a something...",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter something';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_sendmessageController.text.isNotEmpty) {
                              geminiApi1(_sendmessageController.text);
                              _sendmessageController.clear();
                            } else {
                              Fluttertoast.showToast(msg: "Please enter something");
                            }
                          },
                          label: const Text(' Topic'),
                          icon: const Icon(Icons.send_rounded),

                        ),
                        const SizedBox(width: 15,),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                            });
                            geminiApi2(_sendmessageController.text);
                            _sendmessageController.clear();
                          }, label: const Text('Answer'),
                          icon: const Icon(Icons.send_rounded),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
