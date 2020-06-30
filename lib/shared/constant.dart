import 'package:flutter/material.dart';
const textinputdecoration=InputDecoration(

  fillColor: Colors.white,
  filled: true,
  //when we not focused in the label
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0,
      )
  ),
);

