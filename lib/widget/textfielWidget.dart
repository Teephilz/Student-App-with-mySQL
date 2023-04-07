import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
   String? label;
   TextEditingController? controller;
   TextInputType? inputType;
   FormFieldValidator? validator;

   CustomTextField({
     this.label,
     this.controller,
     this.inputType,
     this.validator
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black
        ),
        keyboardType: inputType,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow, width: 0),
            borderRadius: BorderRadius.circular(25)
          )
        ),
      ),
    );
  }
}
