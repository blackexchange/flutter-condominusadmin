import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import '../screens/widgets/widgets.dart';
import '../blocs/blocs.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _orderBloc = BlocProvider.getBloc<OrderBloc>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: _orderBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent)),
              );
            }
            if (snapshot.data!.isNotEmpty) {
              final list = snapshot.data as List;

              return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return OrderTile(list[index]);
                  });
            } else {
              return const Center(
                child: Text(
                  "Nenhum registro encontrado!",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              );
            }
          }),
    );
  }
}
