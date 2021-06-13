import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyBoardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? validationText;
  final Function(dynamic)? onSubmit;
  var maxLength;
  int? maxLines = 1;
  final FocusNode? myNode;
  final FocusNode? nextNode;
  Widget? prefix;
  bool isEnabled;
  Widget? suffix;
  final Function(dynamic)? onSaved;
  EdgeInsetsGeometry? padding;
  TextInputWidget(
      {@required this.labelText,
      @required this.hintText,
      @required this.keyBoardType,
      @required this.obscureText,
      @required this.controller,
      this.onSubmit,
      @required this.onSaved,
      @required this.validationText,
      @required this.textInputAction,
      this.maxLines,
      this.maxLength,
      this.myNode,
      this.nextNode,
      this.prefix,
      this.suffix,
      this.isEnabled = true,
      this.padding});
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding == null
          ? const EdgeInsets.fromLTRB(16.0, 8, 16, 0)
          : widget.padding!,
      child: Column(
        children: <Widget>[
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.labelText!,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
          _textField(),
        ],
      ),
    );
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          keyboardType: widget.keyBoardType,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          focusNode: widget.myNode,
          enabled: widget.isEnabled,
          textInputAction: widget.textInputAction,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            fillColor: widget.isEnabled == true ? Colors.white : Colors.white,
            filled: true,
            errorStyle: TextStyle(fontSize: 12),
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 14),
            prefix: widget.prefix == null
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : widget.prefix,
            prefixStyle: TextStyle(fontSize: 14, color: Colors.grey),
            suffixIcon: widget.suffix == null
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : widget.suffix,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue)),
          ),
          validator: (value) => value == null ? widget.validationText : null,
          onSaved: (value) {
            if (widget.onSaved != null) {
              widget.onSaved!(value);
            }
          },
          onFieldSubmitted: (value) {
            if (widget.myNode != null && widget.nextNode != null) {
              widget.myNode!.unfocus();
              FocusScope.of(context).requestFocus(widget.nextNode);
            }
            if (widget.onSubmit != null) {
              widget.onSubmit!(value);
            }
          }),
    );
  }
}
