import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_flutter_async_value/presentation/pages/login/page.dart';
import 'package:sample_flutter_async_value/infrastructure/services/user.dart';

import 'presentation/pages/home/page.dart';

final scaffoldMessengerKeyProvider = Provider((_) {
  return GlobalKey<ScaffoldMessengerState>();
});

final navigatorKeyProvider = Provider((_) {
  return GlobalKey<NavigatorState>();
});

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.handleAsyncValue<void>(
      loginProvider,
      completeMessage: 'ログインしました',
      complete: (context, _) async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const HomePage();
            },
          ),
        );
      },
    );

    ref.handleAsyncValue<void>(
      logoutStateProvider,
      completeMessage: 'ログアウトしました',
      complete: (context, _) {
        Navigator.pop(context);
      },
    );
    return MaterialApp(
      title: 'Sample Flutter Async Value',
      scaffoldMessengerKey: ref.watch(scaffoldMessengerKeyProvider),
      navigatorKey: ref.watch(navigatorKeyProvider),
      home: const LoginPage(),
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final isLoading = ref.watch(loadingProvider);

            return Stack(
              children: [
                child!,
                if (isLoading)
                  const ColoredBox(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
              ],
            );
          },
        );
      },
    );
  }
}

final loadingProvider = NotifierProvider<LoadingNotifier, bool>(
  LoadingNotifier.new,
);

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;

  void hide() => state = false;
}

extension WidgetRefEx on WidgetRef {
  /// AsyncValueを良い感じにハンドリングする
  void handleAsyncValue<T>(
    ProviderListenable<AsyncValue<T>> asyncValueProvider, {
    void Function(BuildContext context, T data)? complete,
    String? completeMessage,
  }) =>
      listen<AsyncValue<T>>(
        asyncValueProvider,
        (_, next) async {
          final loadingNotifier = read(loadingProvider.notifier);
          if (next.isLoading) {
            loadingNotifier.show();
            return;
          }

          next.when(
            data: (data) async {
              loadingNotifier.hide();

              // 完了メッセージがあればスナックバーを表示する
              if (completeMessage != null) {
                final messengerState =
                    read(scaffoldMessengerKeyProvider).currentState;
                messengerState?.showSnackBar(
                  SnackBar(
                    content: Text(completeMessage),
                  ),
                );
              }
              complete?.call(read(navigatorKeyProvider).currentContext!, data);
            },
            error: (e, s) async {
              loadingNotifier.hide();

              // エラーが発生したらエラーダイアログを表示する
              await showDialog<void>(
                context: read(navigatorKeyProvider).currentContext!,
                builder: (context) => ErrorDialog(error: e),
              );
            },
            loading: loadingNotifier.show,
          );
        },
      );
}

/// エラーダイアログ
class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.error,
  });

  final Object error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('エラー'),
      content: Text(error.toString()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
