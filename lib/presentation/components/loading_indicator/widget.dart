import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = NotifierProvider<LoadingNotifier, bool>(
  LoadingNotifier.new,
);

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}
