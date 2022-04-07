import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

enum SortCriteria { READY_FIRST, READ_LAST }

class OrderBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();

  Stream<List> get outOrders => _ordersController.stream;

  final List<DocumentSnapshot> _orders = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SortCriteria? _criteria;

  OrderBloc() {
    _addOrderListener();
  }

  void onChangeSearch(String search) {
    /* if (search.trim().isEmpty) {
      _ordersController.add(_orders.values.toList());
    } else {
      _ordersController.add(_filter(search.trim()));
    }*/
  }

  /* List<Map<String, dynamic>> filteredUsers =
  List<Map<String, dynamic>> _filter(String search) {
        List.from(_orders.values.toList());
    filteredUsers.retainWhere((element) =>
        element['name'].toUpperCase().contains(search.toUpperCase()));
    return filteredUsers;
  }
    */

  void _addOrderListener() {
    _firestore.collection('orders').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        String uid = element.doc.id;

        switch (element.type) {
          case DocumentChangeType.added:
            _orders.add(element.doc);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((element) => element.id == uid);
            _orders.add(element.doc);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((element) => element.id == uid);

            break;
        }
      });
      _sort();
    });
  }

  void setOrderCriteria(SortCriteria criteria) {
    _criteria = criteria;
    _sort();
  }

  void _sort() {
    switch (_criteria) {
      case SortCriteria.READY_FIRST:
        _orders.sort((a, b) {
          var data = a.data() as Map;
          int sa = data["status"];
          int sb = data["status"];
          if (sa < sb)
            return 1;
          else if (sa > sb)
            return -1;
          else
            return 0;
        });

        break;
      case SortCriteria.READ_LAST:
        _orders.sort((a, b) {
          var data = a.data() as Map;
          int sa = data["status"];
          int sb = data["status"];
          if (sa > sb)
            return 1;
          else if (sa < sb)
            return -1;
          else
            return 0;
        });
        break;
    }
    _ordersController.add(_orders);
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
