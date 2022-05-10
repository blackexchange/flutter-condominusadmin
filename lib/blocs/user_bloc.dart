import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  final Map<String, Map<String, dynamic>> _users = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void onChangeSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  Map<String, dynamic> getUser(String uid) {
    if (_users[uid] != null && _users[uid]!.isNotEmpty) {
      return _users[uid]!;
    } else {
      return {};
    }
  }

  Future<QuerySnapshot> getUnit(String uid) async {
    var docRef = await _firestore
        .collection('units')
        .where('members', arrayContains: uid)
        .get();

    return docRef;
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers =
        List.from(_users.values.toList());
        
    filteredUsers.retainWhere((element) =>
        element['name'].toUpperCase().contains(search.toUpperCase()));
    return filteredUsers;
  }

  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        String uid = element.doc.id;

        switch (element.type) {
          case DocumentChangeType.added:
            _users[uid] = element.doc.data()!;
            _subscribeToOrders(uid);

            break;
          case DocumentChangeType.modified:
            _users[uid]?.addAll(element.doc.data()!);
            _usersController.add(_users.values.toList());

            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unsubscribeToOrders(uid);
            _usersController.add(_users.values.toList());

            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]?['subscription'] = _firestore
        .collection("users")
        .doc(uid)
        .collection("orders")
        .snapshots()
        .listen((event) async {
      _usersController.add(_users.values.toList());
    });
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]?['subscription'].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }
}
