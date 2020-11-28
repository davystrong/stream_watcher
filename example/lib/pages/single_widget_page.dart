import 'package:flutter/material.dart';
import 'package:example/data_bloc.dart';
import 'package:stream_watcher/stream_watcher.dart';

class SingleWidgetPage extends StatelessWidget {
  const SingleWidgetPage({
    Key key,
    this.dataBloc,
  }) : super(key: key);
  final DataBloc dataBloc;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      children: List.generate(
        dataBloc.streamCount,
        (index) => GridTile(
          child: CircularProgressIndicator(
            value: dataBloc.streams[index].watch(context, 0),
          ),
        ),
      ),
    );
  }
}
