// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/request.dart';

import '../../paras/paras.dart';
import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {

  final Controller c = Get.put(Controller());

  var list=[];
  var title="";

    void search(value){
    // TODO 搜索歌曲
  }

  void reload(){
    // TODO 刷新列表
  }
  TextEditingController searchInput=TextEditingController();
  

  Future<void> getPlayList() async {
    if(c.nowPage["name"]=="歌单" && c.nowPage["id"]!.isNotEmpty){
      var resp=await playListRequest(c.nowPage["id"]!);
      try {
        setState(() {
          title=resp["name"];
          list=resp["entry"];
        });
      } catch (_) {}
    }
  }

  @override
  void initState() {
    super.initState();

    ever(c.nowPage, (callback){
      getPlayList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(searchController: search, title: title, subtitle: "合计${list.length}首歌", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: Container(),
          )
        ],
      ),
    );
  }
}