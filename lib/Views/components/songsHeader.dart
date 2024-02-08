// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class songsHeader extends StatefulWidget {
  const songsHeader({super.key});

  @override
  State<songsHeader> createState() => _songsHeaderState();
}

class _songsHeaderState extends State<songsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Color.fromARGB(255, 242, 242, 242),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "序号"
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("标题"),
            )
          ),
          SizedBox(
            width: 70,
            child: Center(
              child: Icon(
                Icons.timer_outlined,
                size: 18,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: Icon(
                Icons.favorite_border_rounded,
                size: 18,
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: Icon(
                Icons.menu_rounded,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}