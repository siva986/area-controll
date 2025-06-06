import 'package:flutter/material.dart';

class DialogRoutePage<T> extends Page<T> {
  final Widget child;

  final bool ignoreBarrior;
  final bool barrierDismissible;

  const DialogRoutePage({required this.child, this.ignoreBarrior = true, this.barrierDismissible = false, super.key});

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      barrierDismissible: false,
      context: context,
      settings: this,
      builder: (context) => Material(type: MaterialType.transparency, child: child),
    );
  }
}

class BottomSheetPage<T> extends Page<T> {
  const BottomSheetPage({
    super.key,
    required this.child,
    this.modalBarrierColor = Colors.transparent,
    this.backgroundColor,
    this.isScrollControlled = false,
    this.ignoreBarrior = false,
    this.padends = 5,
  });

  final Widget child;
  final Color? modalBarrierColor;
  final Color? backgroundColor;
  final bool isScrollControlled;
  final bool ignoreBarrior;
  final double padends;

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      elevation: 0,
      modalBarrierColor: modalBarrierColor,
      isScrollControlled: isScrollControlled,
      // ignoreBarrior: true,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      settings: this,
      builder: (context) => Padding(
        padding: EdgeInsets.all(padends),
        child: child,
      ),
    );
  }
}
