import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../blocs/blocs.dart';

class OrderHeader extends StatelessWidget {
  final DocumentSnapshot? order;
  final _userBloc = BlocProvider.getBloc<UserBloc>();

  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    final orderData = order?.data()! as Map;
    final _user = _userBloc.getUser(orderData["userId"]);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(_user['name']), Text(_user['cpf'])],
          ),
        ),
        FutureBuilder<QuerySnapshot>(
            future: _userBloc.getUnit(orderData["userId"]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
                );
              } else if (snapshot.data?.docs != null) {
                var docUnit = snapshot.data?.docs.first;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      docUnit?['name'],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      docUnit?['building']['name'],
                    ),
                  ],
                );
              } else {
                return Center();
              }
            })
      ],
    );
  }
}
