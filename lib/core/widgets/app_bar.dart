import 'package:arkan_aleiraq/core/widgets/constant.dart';
import 'package:flutter/material.dart';

import '../ navigation/navigation.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/$logo',height: 30,width: 30,),
        ],
      ),
    );
  }
}

class CustomAppBarBack extends StatelessWidget {
  const CustomAppBarBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: (){
                  navigateBack(context);
                },
                child: Icon(Icons.arrow_back_ios_new,color: Colors.black87,)),
            Image.asset('assets/images/$logo',height: 30,width: 30,),
            Container(width: 20,),
          ],
        ),
      ),
    );
  }
}
