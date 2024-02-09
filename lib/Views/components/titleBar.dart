// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../paras/paras.dart';
// import 'package:flutter/cupertino.dart';

class titleBox extends StatefulWidget {

  final ValueChanged searchController;
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final VoidCallback reloadList;

  const titleBox({super.key, required this.searchController, required this.title, required this.subtitle, required this.controller, required this.reloadList});

  @override
  State<titleBox> createState() => _titleBoxState();
}

class _titleBoxState extends State<titleBox> {

  final Controller c = Get.put(Controller());

  bool hoverLocate=false;
  bool hoverReload=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromARGB(255, 203, 255, 144),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            )
          ),
          widget.title!="专辑" && widget.title!="艺人" && widget.title!="搜索" && widget.title!="设置" ?
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverLocate=true; }),
              onExit: (event) => setState(() { hoverLocate=false; }),
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                tween: ColorTween(begin: Colors.grey[800], end: hoverLocate ? c.hoverColor : Colors.grey[800]),
                builder: (_, value, __){
                  return Icon(
                    Icons.my_location_rounded,
                    size: 20,
                    color: value,
                  );
                },
              ),
            ),
          ): Container(),
          SizedBox(width: 10,),
          widget.title!="搜索" && widget.title!="设置" ?
          Stack(
            children: [
              SizedBox(
                width: 200,
                child: Center(
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: c.hoverColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 210, 210, 210),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onEditingComplete: () => widget.searchController(widget.controller.text),
                  ),
                )
              ),
              Positioned(
                child: SizedBox(
                  width: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () => widget.searchController(widget.controller.text),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(width: 5,)
                    ],
                  )
                )
              ),
            ],
          ) : Container(),
          SizedBox(width: 20,),
          widget.title!="搜索" && widget.title!="设置" ?
          GestureDetector(
            onTap: () => widget.reloadList(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverReload=true; }),
              onExit: (event) => setState(() { hoverReload=false; }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hoverReload ? c.hoverColor : c.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}