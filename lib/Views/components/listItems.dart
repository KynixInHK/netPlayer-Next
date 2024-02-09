// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:net_player_next/functions/operations.dart';

class songItem extends StatefulWidget {

  final int index;
  final String title;
  final String artist;
  final int duration;
  final bool isLoved;

  const songItem({super.key, required this.index, required this.title, required this.artist, required this.duration, required this.isLoved,});

  @override
  State<songItem> createState() => _songItemState();
}

class _songItemState extends State<songItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text((widget.index+1).toString()),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ),
          SizedBox(
            width: 70,
            child: Center(
              child: Text(operations().timeConvert(widget.duration)),
            )
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: widget.isLoved ? Icon(
                Icons.favorite_rounded,
                color: Colors.red,
                size: 18,
              ) : Container()
            ),
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: Icon(
                Icons.more_vert_rounded,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }
}