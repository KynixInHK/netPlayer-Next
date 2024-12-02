// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  
  final Controller c = Get.put(Controller());
  bool hoverURL=false;
  bool hoverAbout=false;
  bool hoverWs=false;
  bool refreshing=false;
  bool hoverLang=false;
  final operations=Operations();

  Future<void> refreshLibrary(BuildContext context) async {
    await HttpRequests().refreshLibrary();
    showMessage(true, 'refreshSuccess'.tr, context);
    await operations.getAllSongs(context);
    await operations.getAlbums(context);
    await operations.getArtists(context);
    await operations.getLovedSongs(context);
    operations.nowPlayCheck(context);
    setState(() {
      refreshing=false;
    });
  }

  void wsSetting(BuildContext context){
    var portInput=c.wsPort.value;
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('wsSettings'.tr),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('port'.tr),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(portInput.toString()),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                portInput-=1;
                              });
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.remove_rounded,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                portInput+=1;
                              });
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 15,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                )
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child:  Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () async {
              c.wsPort.value=portInput;
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('wsPort', portInput);
              Navigator.pop(context);
              showDialog(
                context: context, 
                builder: (BuildContext context)=>AlertDialog(
                  title: Text('applyWS'.tr),
                  content: Text('restartNetp'.tr),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text('ok'.tr)
                    )
                  ],
                )
              );
            }, 
            child: Text('finish'.tr)
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          Row(
            children: [
              Column(
                children: [
                  ViewHeader(title: 'settings'.tr, subTitle: '', page: 'settings',),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('savePlayed'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.savePlay.value, 
                                onChanged: (value){
                                  operations.savePlay(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('autoLogin'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.autoLogin.value, 
                                onChanged: (value){
                                  operations.autoLogin(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Platform.isWindows ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('playBackground'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.closeOnRun.value, 
                                onChanged: (value){
                                  operations.closeOnRun(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableShortcuts'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.useShortcut.value, 
                                onChanged: (value){
                                  operations.useShortcut(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableWs'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(()=>
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    activeTrackColor: c.color6,
                                    splashRadius: 0,
                                    value: c.useWs.value, 
                                    onChanged: (value){
                                      operations.useWs(value, context);
                                    }
                                  ),
                                )
                              )
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                wsSetting(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverWs=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverWs=false;
                                  });
                                },
                                child: AnimatedDefaultTextStyle(
                                  style: GoogleFonts.notoSansSc(
                                    color: hoverWs ? c.color6 : c.color5
                                  ), 
                                  duration: const Duration(milliseconds: 200),
                                  child: Text('settings'.tr)
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Platform.isWindows && c.useDesktopLyric ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableKit'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.useLyricKit.value, 
                                onChanged: c.useWs.value ? (value){
                                  operations.useKit(value, context);
                                }: null
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ):Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('serviceUrl'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  final url=Uri.parse(c.userInfo['url']!);
                                  await launchUrl(url);
                                } catch (_) {
                                  return;
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverURL=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverURL=false;
                                  });
                                },
                                child: Obx(()=>
                                  AnimatedDefaultTextStyle(
                                    style: GoogleFonts.notoSansSc(
                                      color: hoverURL ? c.color6 : Colors.black,
                                    ), 
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      c.userInfo['url']??'',
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    )
                                  )
                                ),
                              ),
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('lang'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text('selfLang'.tr),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: (){
                                    operations.selectLanguage(context);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_){
                                      setState(() {
                                        hoverLang=true;
                                      });
                                    },
                                    onExit: (_){
                                      setState(() {
                                        hoverLang=false;
                                      });
                                    },
                                    child: AnimatedDefaultTextStyle(
                                      style: GoogleFonts.notoSansSc(
                                        color: hoverLang ? c.color6 : c.color5
                                      ), 
                                      duration: const Duration(milliseconds: 200),
                                      child: Text('change'.tr)
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: refreshing ? null : (){
                        setState(() {
                          refreshing=true;
                        });
                        refreshLibrary(context);
                      }, 
                      child: Text(
                        'refreshLibrary'.tr,
                        style: GoogleFonts.notoSansSc(
                          color: c.color6
                        ),
                      )
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        operations.showAbout(context);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverAbout=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverAbout=false;
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          style: GoogleFonts.notoSansSc(
                            color: hoverAbout ? c.color6 : Colors.black,
                          ),
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            'aboutNetp'.tr,
                            softWrap: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        ],
      )
    );
  }
}