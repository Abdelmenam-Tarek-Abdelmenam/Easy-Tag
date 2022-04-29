import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

Widget poweredBy(){
  return Container(
      color: ColorManager.blackColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text('By EasyTag',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          ),
        ],
      ),
    );
}