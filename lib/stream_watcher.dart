library stream_watcher;

import 'dart:async';
import 'package:flutter/widgets.dart';

extension StreamState<T> on Stream<T> {
  //Stores all registered contexts for this stream
  static Expando<Set<BuildContext>> _contextsExpando = Expando();
  //Stores the stream subscription
  static Expando<StreamSubscription> _streamSubs = Expando();
  //Stores the latest value of the stream
  static Expando _dataExpando = Expando();

  T watch(BuildContext context, [T seed]) {
    //If this state hasn't already been registered to update with this stream
    if (StreamState._contextsExpando[this] == null) {
      StreamState._contextsExpando[this] = Set();
      StreamState._streamSubs[this] = this.listen((event) {
        if (StreamState._dataExpando[this] != event) {
          StreamState._dataExpando[this] = event;
          //Stop listening for changes if there are no states left
          if (StreamState._contextsExpando[this].isEmpty) {
            StreamState._streamSubs[this].cancel();
            StreamState._contextsExpando[this] = null;
          } else {
            //Otherwise call setState on each registered state
            StreamState._contextsExpando[this].removeWhere((itContext) {
              try {
                //This seems mad: the only way I found to get the
                //current element is to get the ancestor, then the child
                itContext.visitAncestorElements((element) {
                  element.visitChildElements((element) {
                    element.markNeedsBuild();
                    return false;
                  });
                  return false;
                });
                return false;
              } on FlutterError catch (_) {
                return true;
              }
            });
          }
        }
      });
    }
    StreamState._contextsExpando[this].add(context);
    //Return the latest value of the stream
    return StreamState._dataExpando[this] ?? seed;
  }
}
