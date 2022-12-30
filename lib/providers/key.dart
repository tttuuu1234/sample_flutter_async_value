import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldMessengerKeyProvider = Provider((_) {
  return GlobalKey<ScaffoldMessengerState>();
});

final navigatorKeyProvider = Provider((_) {
  return GlobalKey<NavigatorState>();
});
