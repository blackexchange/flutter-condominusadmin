import 'package:condominusadmin/screens/screens.dart';
import 'package:flutter/material.dart';
import './widgets/widgets.dart';
import '../blocs/blocs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBLoc();

  @override
  void initState() {
    super.initState();
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                  title: Text("Erro"), content: Text("Acesso não permitido.")));
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          builder: (context, snapshot) {
            print(snapshot.data);
            switch (snapshot.data) {
              case LoginState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                  ),
                );

              case LoginState.FAIL:
              case LoginState.SUCCESS:
              case LoginState.IDLE:
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(),
                    SingleChildScrollView(
                        child: Container(
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Icon(
                                  Icons.business,
                                  color: Colors.pinkAccent,
                                  size: 160,
                                ),
                                InputField(
                                  icon: Icons.person_outline,
                                  hint: 'Usuário',
                                  obscure: false,
                                  stream: _loginBloc.outEmail,
                                  onChanged: _loginBloc.changeEmail,
                                ),
                                InputField(
                                  icon: Icons.lock_outline,
                                  hint: 'Senha',
                                  obscure: true,
                                  stream: _loginBloc.outPassword,
                                  onChanged: _loginBloc.changePassword,
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                StreamBuilder<bool>(
                                    stream: _loginBloc.outSubmitValid,
                                    builder: (context, snapshot) {
                                      return ElevatedButton(
                                          onPressed: snapshot.hasData
                                              ? _loginBloc.submit
                                              : null,
                                          child: Text('OK'));
                                    })
                              ],
                            ))),
                  ],
                );
              case null:
                return const Center();
            }
          }),
    );
  }
}
