import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

void main() {
  runApp(const ProviderScope(child: _EagerInitialization(child: SampleApp())));
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タイマー開始
    Timer.periodic(const Duration(seconds: 2), (timer) {
      final page = ref.read(pageNameProvider);
      switch (page) {
        case null:
          ref.read(pageNameProvider.notifier).state = Pages.page1;
          print("null -> page1");
          break;
        case Pages.page1:
          ref.read(pageNameProvider.notifier).state = Pages.page2;
          print("page1 -> page2");
          break;
        case Pages.page2:
          ref.read(pageNameProvider.notifier).state = Pages.page3;
          print("page2 -> page3");
          break;
        case Pages.page3:
          ref.read(pageNameProvider.notifier).state = null;
          print("page3 -> null");
          break;
      }
    });

    return child;
  }
}

class SampleApp extends ConsumerWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageNameProvider);
    final pageNotifier = ref.watch(pageNameProvider.notifier);

    return MaterialApp(
      title: 'Sample App',
      home: Navigator(
          pages: [
            MaterialPage(
              child: Scaffold(
                  appBar: AppBar(), body: const Center(child: Text('Home'))),
            ),
            if (page == Pages.page1 ||
                page == Pages.page2 ||
                page == Pages.page3)
              MaterialPage(
                child: Page1(onPressed: () => pageNotifier.state = Pages.page2),
              ),
            if (page == Pages.page2 || page == Pages.page3)
              MaterialPage(
                child: Page2(onPressed: () => pageNotifier.state = Pages.page3),
              ),
            if (page == Pages.page3) const MaterialPage(child: Page3())
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            ref.read(pageNameProvider.notifier).state = switch (page) {
              null => null,
              Pages.page1 => null,
              Pages.page2 => Pages.page1,
              Pages.page3 => Pages.page2,
            };
            return true;
          }),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text('Page 1'),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Page 2へ'),
          ),
        ],
      )),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key, required this.onPressed}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text('Page 2'),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Page 3へ'),
          ),
        ],
      )),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Page 3')),
    );
  }
}

enum Pages {
  page1,
  page2,
  page3,
}

@riverpod
class PageName extends _$PageName {
  @override
  Pages? build() {
    return null;
  }
}
