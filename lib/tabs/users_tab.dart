import 'package:flutter/material.dart';
import '../screens/widgets/widgets.dart';
import '../blocs/blocs.dart';

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userBloc = UserBloc();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: TextField(
            onChanged: _userBloc.onChangeSearch,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: "Pesquisar",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(Icons.search, color: Colors.white),
                border: InputBorder.none),
          ),
        ),
        Expanded(
            child: StreamBuilder<List>(
                stream: _userBloc.outUsers,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.pinkAccent)),
                    );
                  }

                  if (snapshot.data!.isNotEmpty) {
                    final list = snapshot.data as List;

                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: UserTile(list[index]),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: list.length);
                  } else {
                    return const Center(
                      child: Text(
                        "Nenhum usuário encontrado!",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  }
                }))
      ],
    );
  }
}
