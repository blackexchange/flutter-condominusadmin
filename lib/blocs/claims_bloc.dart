import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class ClaimsBloc extends BlocBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _claimsController = BehaviorSubject<List>();
  final Map<String, Map<String, dynamic>> _reserve = {};

  final DocumentSnapshot? building;
  final _dataController = BehaviorSubject<Map<String, dynamic>?>();

  Stream<List> get outClaims => _claimsController.stream;

  ClaimsBloc({required this.building}) {
    _addReserveListener();
  }

  void _addReserveListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((element) {
        String uid = element.doc.id;

        switch (element.type) {
          case DocumentChangeType.added:
            _reserve[uid] = element.doc.data()!;
            // _subscribeToOrders(uid);

            break;
          case DocumentChangeType.modified:
            _reserve[uid]?.addAll(element.doc.data()!);
            //  _reserveController.add(_reserve.values.toList());

            break;
          case DocumentChangeType.removed:
            _reserve.remove(uid);
            //  _unsubscribeToOrders(uid);
            //_reserveController.add(_reserve.values.toList());

            break;
        }
      });
    });
  }
}
