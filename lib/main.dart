import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp> {
  // 遷移したい画面の名前
  PageName? routeName = PageName.page1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      home: Navigator(
          pages: [
            const MaterialPage(
              child: Scaffold(body: Center(child: Text("デフォルト"))),
            ),
            if (routeName == PageName.page1)
              MaterialPage(
                child: Page1(
                  onPressed: () => updateRouteName(PageName.page2),
                ),
              )
            else if (routeName == PageName.page2)
              const MaterialPage(child: Page2())
            else if (routeName == PageName.page3)
              const MaterialPage(child: Page3())
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            setState(() {
              routeName = null;
            });
            return true;
          }),
    );
  }

  void updateRouteName(PageName pageName) {
    setState(() {
      routeName = pageName;
    });
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
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Page 2')),
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

enum PageName {
  page1,
  page2,
  page3,
}
