import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  bool get isActive => _timer?.isActive ?? false;
}

extension TimeEx on TimeOfDay {
  String get toNomalTime {
    final regex = RegExp(r'TimeOfDay\((\d{2}:\d{2})\)');
    final match = regex.firstMatch(toString());

    if (match != null) {
      return match.group(1) ?? "";
    } else {
      return "";
    }
  }
}
