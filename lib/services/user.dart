import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userServiceProvider = Provider(UserService.new);

/// ログイン処理状態
final loginProvider = StateProvider<AsyncValue<void>>((_) {
  return const AsyncValue.data(null);
});

/// ログアウト処理状態
final logoutStateProvider = StateProvider<AsyncValue<void>>(
  (_) => const AsyncValue.data(null),
);

class UserService {
  UserService(this.ref);

  final Ref ref;

  /// ログイン
  Future<void> login() async {
    final notifier = ref.read(loginProvider.notifier);

    // ログイン結果をローディング中に変更
    notifier.state = const AsyncValue.loading();

    // ログイン実行
    notifier.state = await AsyncValue.guard(() async {
      // ローディングを出したいので2秒待つ
      await Future<void>.delayed(const Duration(seconds: 2));

      // エラー時の動作が確認できるように1/2の確率で例外を発生させる
      if ((Random().nextInt(2) % 2).isEven) {
        throw 'ログインできませんでした。';
      }
    });
  }

  /// ログアウトする
  Future<void> logout() async {
    final notifier = ref.read(logoutStateProvider.notifier);

    // ログイン結果をローディング中にする
    notifier.state = const AsyncValue.loading();

    // ログイン処理を実行する
    notifier.state = await AsyncValue.guard(() async {
      // ローディングを出したいので2秒待つ
      await Future<void>.delayed(const Duration(seconds: 2));

      // エラー時の動作が確認できるように1/2の確率で例外を発生させる
      if ((Random().nextInt(2) % 2).isEven) {
        throw 'ログアウトできませんでした。';
      }
    });
  }
}
