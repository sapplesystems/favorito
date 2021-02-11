import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/material.dart';

class showPopup {
  Widget widget;
  Function callback;
  BuildContext ctx;
  SizeManager sm;
  showPopup({this.widget, this.callback, this.ctx, this.sm});

  show() => Navigator.push(
          ctx,
          PopupLayout(
              top: sm.h(36),
              left: sm.w(3),
              right: sm.w(3),
              bottom: sm.h(30),
              child: PopupContent(content: widget)))
      .whenComplete(() => callback());
}
