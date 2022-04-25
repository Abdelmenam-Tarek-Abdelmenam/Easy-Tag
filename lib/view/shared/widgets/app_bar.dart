import 'package:flutter/material.dart';


PreferredSizeWidget appBar(title,{actions}){
  return AppBar(
    title:  Text(title),
    elevation: 0,
    backgroundColor: Colors.white.withOpacity(0),
    foregroundColor: Colors.black,
    actions: actions,
  );
}

