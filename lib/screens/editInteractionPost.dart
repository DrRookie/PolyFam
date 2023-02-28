

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polyfam/models/tweet_post.dart';
import 'package:polyfam/services/tweetPost_service.dart';

import 'package:provider/provider.dart';


class EditInteractionScreen extends StatefulWidget {
  static String routeName = '/edit-interactionpost';

  @override
  State<EditInteractionScreen> createState() => _EditInteractionScreenState();
}

class _EditInteractionScreenState extends State<EditInteractionScreen> {
  var form = GlobalKey<FormState>();

  String? tweet;

  String? tag;

  DateTime? postDate;


  void saveForm(String id ) {
    bool isValid = form.currentState!.validate();
    postDate ??= DateTime.now();

    if (isValid) {
      form.currentState!.save();


      print(tweet);
      print(tag);

      TweetPostService fsTweetService = TweetPostService();
      fsTweetService.editTweetPost(id, tweet, tag, postDate);

      // Hide the keyboard
      FocusScope.of(context).unfocus();
      // Resets the form
      form.currentState!.reset();
      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text('Tweet updated successfully!'),));
      Navigator.of(context).pushReplacementNamed('/interactionscreen');
    }
  }


  @override
  Widget build(BuildContext context) {
    TweetPost selectedTweetPost = ModalRoute.of(context)?.settings.arguments as TweetPost;

    return Scaffold(
        appBar: AppBar(
          title: Text('Update Tweet'),
          actions: [
            IconButton(onPressed: (){saveForm(selectedTweetPost.id);}, icon: Icon(Icons.save))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              children: [

                TextFormField(
                  initialValue: selectedTweetPost.tweet,
                  decoration: InputDecoration(label: Text("What's Happening?")),
                  onSaved: (value) {
                    tweet = value as String;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    }
                  },
                ),
                TextFormField(
                  initialValue: selectedTweetPost.tag,
                  decoration: InputDecoration(label: Text('Provide a tag')),
                  onSaved: (value) {
                    tag = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please do not leave it empty";
                    }
                  },
                ),

              ],
            ),
          ),
        )
    );
  }
}