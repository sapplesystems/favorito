import 'package:Favorito/component/PopupContent.dart';
import 'package:Favorito/component/PopupLayout.dart';
import 'package:Favorito/config/SizeManager.dart';
import 'package:flutter/material.dart';

class showPopup {
  Widget widget;
  Function callback;
  BuildContext ctx;
  SizeManager sm;
  double sizesLeft;
  double sizesRight;
  double sizesTop;
  double sizesBottom;
  showPopup(
      {this.widget,
      this.callback,
      this.ctx,
      this.sm,
      this.sizesBottom,
      this.sizesLeft,
      this.sizesRight,
      this.sizesTop}) {
    sizesBottom = sizesBottom ?? 33;
    sizesLeft = sizesLeft ?? 3;
    sizesRight = sizesRight ?? 33;
    sizesTop = sizesTop ?? 3;
  }

  show() => Navigator.push(
          ctx,
          PopupLayout(
              top: sm.h(sizesTop),
              left: sm.w(sizesLeft),
              right: sm.w(sizesRight),
              bottom: sm.h(sizesBottom),
              child: PopupContent(content: widget)))
      .whenComplete(() => callback());
}
