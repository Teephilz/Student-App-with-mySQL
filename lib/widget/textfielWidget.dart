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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
            width: 1
          )
        ),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black
          ),
          keyboardType: inputType,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)
            )
          ),
        ),
      ),
    );
  }
}
