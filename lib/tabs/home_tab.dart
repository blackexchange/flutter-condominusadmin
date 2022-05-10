import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/home/components/components.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search, color: Colors.white),
                border: InputBorder.none),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("units").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
                  );
                } else {
                  final int cont = snapshot.data!.docs.length;
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cont,
                      itemBuilder: (context, index) {
                        return HomeBuildingTile(snapshot.data!.docs[index]);
                      });
                }
              }),
        ),
        Expanded(
          flex: 4,
          child: Container(),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
