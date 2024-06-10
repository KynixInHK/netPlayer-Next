// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class lovedView extends StatefulWidget {
  const lovedView({super.key});

  @override
  State<lovedView> createState() => _lovedViewState();
}

class _lovedViewState extends State<lovedView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '喜欢的歌曲', subTitle: ''),
              SizedBox(height: 10,),
              songHeader()
            ],
          )
        ],
      )
    );
  }
}