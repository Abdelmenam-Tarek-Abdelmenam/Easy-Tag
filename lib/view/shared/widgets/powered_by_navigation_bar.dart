import 'package:flutter/material.dart';
import '../../resources/color_manager.dart';

Widget poweredBy(){
  return Container(
      color: ColorManager.mainBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text('by Homation',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
          ),
        ],
      ),
    );
}