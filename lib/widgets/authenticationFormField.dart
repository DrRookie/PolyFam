import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationFormField extends StatefulWidget {
  final controller;
  bool enable;
  Color color;
  String label;
  bool obscureText;
  IconData prefixIcon;
  Widget? suffixIconWidgetWhenControllerIsEmptyIsTrue;
  Widget? suffixIconWidgetWhenControllerIsEmptyIsFalse;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;
  String? stringFromDatabase;

  AuthenticationFormField({required this.controller,required this.enable,required this.color,required this.label,required this.obscureText,required this.prefixIcon,required this.suffixIconWidgetWhenControllerIsEmptyIsTrue,required this.suffixIconWidgetWhenControllerIsEmptyIsFalse,required this.keyboardType,required this.validator,required this.onSaved,this.stringFromDatabase=''});

  @override
  State<AuthenticationFormField> createState() => _AuthenticationFormFieldState();
}

class _AuthenticationFormFieldState extends State<AuthenticationFormField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.stringFromDatabase;
    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 255,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: widget.controller,
      enabled: widget.enable,
      style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold,fontSize:22,color: widget.enable ? widget.color : widget.color.withOpacity(0.5)),
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.prefixIcon, color: widget.enable ? widget.color : widget.color.withOpacity(0.5),),
        suffixIcon: widget.controller.text.isEmpty ?
        widget.suffixIconWidgetWhenControllerIsEmptyIsTrue :
        widget.suffixIconWidgetWhenControllerIsEmptyIsFalse,
        label: Text(widget.label, style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold,fontSize:22,color: widget.enable ? widget.color : widget.color.withOpacity(0.5)),),
        helperStyle: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold,fontSize:18,color: widget.enable ? widget.color : widget.color.withOpacity(0.5)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.color),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.color),
          borderRadius: BorderRadius.circular(7),
        ),
        errorStyle: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.bold,fontSize:18,color: Colors.redAccent),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(7),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(7)
        ),
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}