import 'package:condominusadmin/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UnitSizes extends FormField<List> {
  UnitSizes(
      {required BuildContext context,
      required List initialValue,
      required FormFieldSetter<List> onSaved,
      required FormFieldValidator<List> validator})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) => SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: state.value!
                        .map((e) => GestureDetector(
                              onLongPress: () =>
                                  state.didChange(state.value!..remove(e)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 3)),
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
                        .toList()
                      ..add(GestureDetector(
                        onTap: () async {
                          String size = await showDialog(
                              context: context,
                              builder: (context) => AddSizeDialog());
                          state.didChange(state.value!..add(size));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: state.hasError
                                      ? Colors.red
                                      : Colors.blueAccent,
                                  width: 3)),
                          alignment: Alignment.center,
                          child: Text(
                            "+",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  ),
                ));
}
