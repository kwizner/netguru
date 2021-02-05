import 'dart:async';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:netguru/features/add_new_value/add_new_page.dart';
import 'package:netguru/features/favorites/favorites_page.dart';
import 'package:netguru/features/values/values_page.dart';
import 'package:netguru/helpers/netguru_values_manager.dart';
import 'package:netguru/locator/service_locator.dart';
import 'package:netguru/resources/strings.dart';

class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final _valuesManager = getIt.get<NetguruValuesManager>();
  final _random = Random();

  int _generatedValue = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _generatedValue = _random.nextInt(_valuesManager.values.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NG Values'),
        actions: [
          IconButton(
            onPressed: () {
              _valuesManager.addToFavoriteAt(_generatedValue);
            },
            icon: Icon(
              Icons.favorite,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          )
        ],
      ),
      floatingActionButton: OpenContainer(
        closedShape: CircleBorder(),
        closedElevation: 10,
        transitionDuration: Duration(milliseconds: 800),
        closedBuilder: (_, __) => FloatingActionButton(
          elevation: 10,
          foregroundColor: Colors.black,
          child: Icon(Icons.add),
          backgroundColor: Colors.white,
        ),
        openBuilder: (_, __) => AddNewValuePage(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: Text(
              _generatedValue != -1
                  ? _valuesManager.values[_generatedValue].value
                  : 'initializing',
              key: ValueKey<String>(
                  _valuesManager.values[_generatedValue].value),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            children: [
              SizedBox(width: 16.0),
              Material(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ValuesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(-1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve),
                        );

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.format_quote_sharp, color: Colors.white),
                        Text(
                          Strings.valuesBottomBar,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Material(
                borderRadius: BorderRadius.circular(8.0),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          FavoritesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve),
                        );

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.white),
                        Text(
                          Strings.favoritesBottomBar,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
