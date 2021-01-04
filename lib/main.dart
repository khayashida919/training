import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Training/Calendar/calendar.dart';
import 'Training/Set/set.dart';
import 'Training/Setting/setting.dart';
import 'Training/Setup/setup.dart';

void main() { runApp(PlankTraining()); }

class PageIndex with ChangeNotifier {
  int value = 0;

  void changeIndex(int index) {
    value = index;
    notifyListeners();
  }
}

class PlankTraining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PlankTraining',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: ChangeNotifierProvider(
          create: (_) => PageIndex(),
          child: _RootScreen()
        ),
    );
  }
}

PageController pageController = PageController(initialPage: 0);

class _RootScreen extends StatelessWidget {

  final _pageWidgets = [
    SetupScreen(),
    CalendarScreen(),
    SetScreen(),
    SettingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            context.read<PageIndex>().changeIndex(index);
          },
          children: _pageWidgets,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: "トレーニング"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "カレンダー"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "セット"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "設定"),
          ],
          currentIndex: context.watch<PageIndex>().value,
          fixedColor: Colors.redAccent,
          onTap: (index) {
            context.read<PageIndex>().changeIndex(index);
            pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          type: BottomNavigationBarType.fixed,
        )
    );
  }
}
