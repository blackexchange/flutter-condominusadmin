import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './building.dart';

import '../../screens/screens.dart';
import '../../blocs/blocs.dart';

class BuildingScreen extends StatefulWidget {
  final DocumentSnapshot? building;

  BuildingScreen({this.building});

  @override
  State<BuildingScreen> createState() => _BuildingScreenState(building);
}

class _BuildingScreenState extends State<BuildingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildingBloc _BuildingBloc;

  _BuildingScreenState(DocumentSnapshot? building)
      : _BuildingBloc = BuildingBloc(building: building);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);

    InputDecoration _bDecoration(String label) {
      return InputDecoration(
          labelText: label, labelStyle: TextStyle(color: Colors.grey));
    }

    return Scaffold(
      floatingActionButton: _buildFloating(),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book), label: "Registros"),
            BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Reservas"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: "Agenda"),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money), label: "Financeiro"),
          ],
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.building?['title']),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
            },
            icon: Icon(Icons.vertical_split),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _page = page;
          });
        },
        children: [
          Container(
            color: Colors.grey.shade100,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("units")
                    .doc(widget.building?.id)
                    .collection('claims')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.blueAccent)),
                    );
                  } else {
                    final int cont = snapshot.data!.docs.length;

                    return ListView.builder(
                        itemCount: cont,
                        itemBuilder: (context, index) {
                          return ClaimsTile(snapshot.data!.docs[index]);
                        });
                  }
                }),
          ),
          Container(
            color: Colors.grey.shade100,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("units")
                    .doc(widget.building?.id)
                    .collection('reserves')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.blueAccent)),
                    );
                  } else {
                    final int cont = snapshot.data!.docs.length;

                    return ListView.builder(
                        itemCount: cont,
                        itemBuilder: (context, index) {
                          return ReservesTile(snapshot.data!.docs[index]);
                        });
                  }
                }),
          ),
          Container(
            color: Colors.grey.shade100,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("units")
                    .doc(widget.building?.id)
                    .collection('agenda')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.blueAccent)),
                    );
                  } else {
                    final int cont = snapshot.data!.docs.length;

                    return ListView.builder(
                        itemCount: cont,
                        itemBuilder: (context, index) {
                          return AgendaTile(snapshot.data!.docs[index]);
                        });
                  }
                }),
          ),
          Container(
            color: Colors.grey.shade100,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("units")
                    .doc(widget.building?.id)
                    .collection('financeiro')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.blueAccent)),
                    );
                  } else {
                    final int cont = snapshot.data!.docs.length;

                    return ListView.builder(
                        itemCount: cont,
                        itemBuilder: (context, index) {
                          return FinanceiroTile(snapshot.data!.docs[index]);
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 2:
        return SpeedDial(
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.date_range,
                  color: Colors.blueAccent,
                ),
                backgroundColor: Colors.lightBlue,
                label: "Nova Agenda",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {}),
            SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                backgroundColor: Colors.lightBlue,
                label: "Nova Receita",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  // _orderBloc?.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );

      case 3:
        return SpeedDial(
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          children: [
            SpeedDialChild(
                child: Icon(
                  Icons.remove,
                  color: Colors.blueAccent,
                ),
                //  backgroundColor: Colors.lightBlue,
                label: "Nova Despesa",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditFinanceiro(
                            unit: widget.building,
                          )));
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                // backgroundColor: Colors.white,
                label: "Nova Receita",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  // _orderBloc?.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
            SpeedDialChild(
                child: Icon(
                  Icons.book,
                  color: Colors.blueAccent,
                ),
                //  backgroundColor: Colors.lightBlue,
                label: "Nova Conta",
                labelStyle: TextStyle(fontSize: 14),
                onTap: () {
                  showDialog(
                      context: context, builder: (context) => ContaDialog());
                  // _orderBloc?.setOrderCriteria(SortCriteria.READY_FIRST);
                }),
          ],
        );
    }
    return Center();
  }
}
