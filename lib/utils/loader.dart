import 'package:area_control/core/services/navigator/navigator_service.dart';
import 'package:area_control/utils/headline.dart';
import 'package:flutter/material.dart';

Future loader(Future onProgrees, {String msg = 'Loading...'}) {
  showDialog(
    context: NavigatorService.globalContext,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(constraints: BoxConstraints(maxHeight: 20, maxWidth: 20), color: Colors.blue, strokeWidth: 2),
                const SizedBox(height: 10),
                Headline(msg),
              ],
            ),
          ),
        ),
      );
    },
  );

  return onProgrees.whenComplete(() {
    Navigator.of(NavigatorService.globalContext).pop();
  });
}
