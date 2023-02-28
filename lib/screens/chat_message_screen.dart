

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:polyfam/models/chat_message.dart';


class ChatMessageScreen extends StatelessWidget {
  static String routeName = '/chatmessagescreen';
  @override
  Widget build(BuildContext context) {
   return Scaffold (
     appBar:  AppBar(
       automaticallyImplyLeading: false,
       title: Row(
         children: [
           BackButton(),
           CircleAvatar(
             backgroundImage: AssetImage("images/user_2.png"),

           ),
           SizedBox(width: 10,),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 "Esther Howard",
                 style: TextStyle(fontSize: 16),
               ),
               Text("Active 3m ago",
                 style: TextStyle(fontSize: 12),)
             ],
           ),
         ],
       ),
     ),
     body: Column(
       children: [
         Expanded(
           child: Padding(
             padding: const EdgeInsets.symmetric(
               horizontal: 10,
             ),
             child: ListView.builder(
               itemCount: demoChatMessages.length,
                 itemBuilder: (context, index) => Message(message: demoChatMessages[index],)),
           )),

         ChatInputField(),
       ],
     ),


   );

  }

}


class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,

  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    Widget messageContent(ChatMessage message) {

      switch(message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        default:
          return SizedBox();
      }


    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,

      ),
      child: Row(
        mainAxisAlignment: message.isSender? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender)
            ... [
              CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage("images/user_2.png"),
              ),
              SizedBox(
                width: 5,
              )
            ],
         messageContent(message),
          if (message.isSender)  MessageStatusDot(status: message.messageStatus)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return Colors.red;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return Colors.green;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 15),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}









class AudioMessage extends StatelessWidget {
  final ChatMessage message;

  const AudioMessage({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 3
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.greenAccent.withOpacity(message.isSender ? 1 : 0.1)
      ),
      child: Row(
        children: [
          Icon(Icons.play_arrow, color: message.isSender ? Colors.white: Colors.green,),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.green.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text("0.37", style: TextStyle(fontSize: 12, color:  message.isSender ? Colors.white : null),)

        ],
      ),
    );
  }

}







class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15
      ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(message.isSender ? 1 : 0.1),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Text(message.text, style: TextStyle(
          color: message.isSender ? Colors.white: Colors.blueGrey,
        ),));
  }
}










class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15
      ),
      decoration:  BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(offset: Offset(0,4),
              blurRadius: 32,
          color: Color(0xFF0087949).withOpacity(0.08))]),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: Colors.blueGrey),
            SizedBox(width: 1.5),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15
                ),
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.blueGrey.withOpacity(0.64),),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.attach_file, color: Colors.blueGrey.withOpacity(0.64),),
                    SizedBox(width: 10,),
                    Icon(Icons.camera_alt_outlined, color: Colors.blueGrey.withOpacity(0.64),),

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