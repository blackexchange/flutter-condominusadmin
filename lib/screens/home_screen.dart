import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import './widgets/widgets.dart';
import '../blocs/blocs.dart';
import '../tabs/tabs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  UserBloc? _userBloc;
  OrderBloc? _orderBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc();
    _orderBloc = OrderBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.blueGrey,
              primaryColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: TextStyle(color: Colors.white))),
          child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (page) {
              _pageController.animateToPage(page,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Moradores"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), label: "Solicitações"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.business), label: "Unidades"),
            ],
          ),
        ),
        body: BlocProvider(
          blocs: [Bloc((i) => UserBloc()), Bloc((i) => OrderBloc())],
          dependencies: [],
          child: SafeArea(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _page = page;
                });
              },
              children: [
                HomeTab(),
                UsersTab(),
                OrdersTab(),
                BuildingsTab(),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFloating());
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return Center();
      case 2:
        return SpeedDial(
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          child: Icon(Icons.sort),
          backgroundColor: Colors.lightBlue,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.blueAccent,
                ),
                backgroundColor: Colors.lightBlue,
                label: "Concluídos Abaixo",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {}),
            SpeedDialChild(
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.blueAccent,
                ),
                backgroundColor: Colors.lightBlue,
                label: "Concluídos Acima",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  _orderBloc?.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
      case 3:
        return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context, builder: (context) => EditBuilding());
            });
    }
    return Center();
  }
}
