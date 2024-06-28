// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/SideBar.dart';
import 'package:net_player_next/View/components/playBar.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/View/functions/ws.dart';
import 'package:net_player_next/View/mainViews/album.dart';
import 'package:net_player_next/View/mainViews/all.dart';
import 'package:net_player_next/View/mainViews/artist.dart';
import 'package:net_player_next/View/mainViews/loved.dart';
import 'package:net_player_next/View/mainViews/playList.dart';
import 'package:net_player_next/View/mainViews/search.dart';
import 'package:net_player_next/View/mainViews/settings.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smtc_windows/smtc_windows.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {

  final Controller c = Get.put(Controller());
  late Worker listener;
  late Worker lineListener;
  
  // 是否保存->(是)加载播放信息->是否后台播放->是否所有歌曲随机播放->是否启用全局快捷键->是否自定义播放模式
  Future<void> initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savePlay=prefs.getBool('savePlay');
    if(savePlay!=false){
      final nowPlay=prefs.getString('nowPlay');
      if(nowPlay!=null){
        Map<String, dynamic> decodedMap = jsonDecode(nowPlay);
        Map<String, Object> tmpList=Map<String, Object>.from(decodedMap);
        c.nowPlay.value=tmpList;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Operations().nowPlayCheck(context);
        });
      }
    }else{
      c.savePlay.value=false;
    }
    final closeOnRun=prefs.getBool('closeOnRun');
    if(closeOnRun==false){
      c.closeOnRun.value=false;
    }
    final fullRandomPlay=prefs.getBool('fullRandom');
    if(fullRandomPlay==true && savePlay!=false){
      c.fullRandom.value=true;
    }
    final useShortcut=prefs.getBool('useShortcut');
    if(useShortcut==false){
      c.useShortcut.value=false;
    }
    final playMode=prefs.getString('playMode');
    if(playMode!=null && playMode!='list'){
      c.playMode.value=playMode;
    }
    final volume=prefs.getInt('volume');
    if(volume!=null && volume!=100){
      c.volume.value=volume;
    }
    final ws=prefs.getBool('useWs');
    if(ws==true){
      c.useWs.value=true;
      c.ws=WsService();
    }
    Operations().initHotkey(context);
  }

  void lyricChange(int val){
    if(c.lyric.isEmpty){
      return;
    }
    try {
      var content=c.lyric[c.lyricLine.value-1]['content'];
      if(c.useWs.value){
        c.ws.sendMsg(content);
      }
    } catch (_) {}
    
  }

  Future<void> nowplayChange(Map val) async {
    // 保存现在播放的内容
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nowPlay', jsonEncode(val));
    c.lyricLine.value=0;
    // 如果id不为空，获取歌词
    c.lyric.value=[
      {
        'time': 0,
        'content': '查找歌词中...',
      }
    ];
    var content='查找歌词中...';
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    if(val['id']!=''){
      Operations().getLyric();
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    listener=ever(c.nowPlay, (val)=>nowplayChange(val));
    lineListener=ever(c.lyricLine, (val)=>lyricChange(val));
    initSMTC();
  }

  void initSMTC(){
    if(Platform.isWindows){
      c.smtc = SMTCWindows(
        metadata: MusicMetadata(
          title: c.nowPlay["title"]??'',
          album: c.nowPlay["album"]??'',
          albumArtist: c.nowPlay["artist"]??'',
          artist: c.nowPlay["artist"]??'',
          thumbnail: "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}",
        ),
        config: const SMTCConfig(
          fastForwardEnabled: false,
          nextEnabled: true,
          pauseEnabled: true,
          playEnabled: true,
          rewindEnabled: true,
          prevEnabled: true,
          stopEnabled: true,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // Listen to button events and update playback status accordingly
          c.smtc.buttonPressStream.listen((event) {
            switch (event) {
              case PressedButton.play:
                // Update playback status
                Operations().play();
                c.smtc.setPlaybackStatus(PlaybackStatus.Playing);
                break;
              case PressedButton.pause:
                Operations().pause();
                c.smtc.setPlaybackStatus(PlaybackStatus.Paused);
                break;
              case PressedButton.next:
                // print('Next');
                Operations().skipNext();
                break;
              case PressedButton.previous:
                // print('Previous');
                Operations().skipPre();
                break;
              case PressedButton.stop:
                c.smtc.setPlaybackStatus(PlaybackStatus.Stopped);
                c.smtc.disableSmtc();
                break;
              default:
                break;
            }
          });
        } catch (e) {
          // print("Error: $e");
        }
      });
    }
  }

  @override
  void dispose() {
    listener.dispose();
    c.smtc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 150,
                child: sideBar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(()=>
                      IndexedStack(
                        index: c.pageIndex.value,
                        children: const [
                          allView(),
                          lovedView(),
                          artistView(),
                          albumView(),
                          playListView(),
                          searchView(),
                          settingsView()
                        ],
                      )
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        const SizedBox(
          height: 80,
          child: playBar(),
        )
      ],
    );
  }
}