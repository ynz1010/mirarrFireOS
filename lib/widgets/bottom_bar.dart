import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Mirarr/moviesPage/mainPage.dart';
import 'package:Mirarr/seriesPage/seriesPage.dart';
import 'package:Mirarr/widgets/search_screen.dart';
import 'package:Mirarr/widgets/shelf_page.dart';
import 'package:Mirarr/widgets/login.dart';
import 'package:Mirarr/widgets/profile.dart';
import 'package:hive/hive.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void toMovies() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MovieSearchScreen()));
  }

  void toSeries() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SerieSearchScreen()));
  }

  void toSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  void toShelf() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ShelfPage()));
  }

  void toAccount() async {
    final box = await Hive.openBox('sessionBox');
    final sessionData = box.get('sessionData');
    if (sessionData != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  void _handleRemoteNavigation(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + 5) % 5;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % 5;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.select) {
        switch (_selectedIndex) {
          case 0: toMovies(); break;
          case 1: toSeries(); break;
          case 2: toSearch(); break;
          case 3: toShelf(); break;
          case 4: toAccount(); break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleRemoteNavigation,
      child: BottomNavigationBar(
        selectedItemColor: Theme.of(context).highlightColor,
        selectedIconTheme: IconThemeData(color: Theme.of(context).highlightColor),
        selectedFontSize: 16,
        unselectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0: toMovies(); break;
              case 1: toSeries(); break;
              case 2: toSearch(); break;
              case 3: toShelf(); break;
              case 4: toAccount(); break;
            }
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.local_movies), label: 'Series'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shelves), label: 'Shelf'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
