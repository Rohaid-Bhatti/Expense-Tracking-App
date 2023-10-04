import 'package:flutter/material.dart';

Widget TextFieldWidget(String label, controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 5,),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        maxLines: 1,
      ),
    ],
  );
}