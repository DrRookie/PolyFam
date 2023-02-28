import 'dart:io';
import 'package:flutter/material.dart';
import 'package:polyfam/widgets/imageBottomSheet.dart';

//for profile picture

class EditProfilePicture extends StatefulWidget {
  File? profilePic;
  Function pickImage;
  String? imageUrl;

  EditProfilePicture(this.profilePic, this.pickImage, [this.imageUrl]);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 90,
            backgroundColor: Color(0xffFAC783),
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Colors.white,
              backgroundImage: widget.profilePic == null && (widget.imageUrl == null || widget.imageUrl == '') ?
              null :
              (widget.profilePic == null && widget.imageUrl != null && widget.imageUrl != '' ?
              NetworkImage(widget.imageUrl!) as ImageProvider :
              FileImage(widget.profilePic!) as ImageProvider
              ),
              child: widget.profilePic == null && (widget.imageUrl == null || widget.imageUrl == '') ?
              Image.asset('images/photoholder.jpg',height: 205, width: 115,) :
              null,
            ),
          ),
          if (widget.profilePic != null || (widget.imageUrl != null && widget.imageUrl != ''))
            Positioned(
              bottom: 0,
              left: 0,
              child: CircleAvatar(
                  backgroundColor: Color(0xffFAC783),
                  radius: 30,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.close, color: Color(0xff11463C), size: 40),
                    onPressed: () {
                      setState(() {
                        if (widget.profilePic != null) {
                          widget.profilePic = null;
                        }
                        if (widget.imageUrl != null && widget.imageUrl != '') {
                          widget.imageUrl = '';
                        }
                      });
                    },
                  )
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
                backgroundColor: Color(0xffFAC783),
                radius: 30,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit, color: Color(0xff11463C), size: 40),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor : Colors.white,
                      context: context,
                      builder: ((builder) => CustomBottomSheet(widget.pickImage)),
                    );
                  },
                )
            ),
          )
        ],
      ),
    );
  }
}