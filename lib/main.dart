import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_flutter_async_value/presentation/components/loading_indicator/widget.dart';
import 'package:sample_flutter_async_value/presentation/extension/widget_ref.dart';
import 'package:sample_flutter_async_value/presentation/pages/login/page.dart';
import 'package:sample_flutter_async_value/infrastructure/services/user.dart';

import 'presentation/pages/home/page.dart';
import 'providers/key.dart';

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
                    child: LoadingIndicator(),
                  )
              ],
            );
          },
        );
      },
    );
  }
}
